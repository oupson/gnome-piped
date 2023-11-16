namespace Piped.PipedApi {
    private delegate void WorkerFunc ();

    private class Worker {
        private WorkerFunc func;

        public Worker(WorkerFunc func) {
            this.func = func;
        }

        public void run() {
            this.func();
        }
    }

    public errordomain ApiErrorDomain{
        JSON_ERROR
    }

    public class ApiClient {
        private Soup.Session session;
        private ThreadPool<Worker> pool;
        private string base_url;

        private ApiClient(string base_url) throws ThreadError {
            this.base_url = base_url;
            this.session = new Soup.Session();
            session.set_user_agent("curl/8.4.0");

            this.pool = new ThreadPool<Worker>.with_owned_data ((worker) => {
			    // Call worker.run () on thread-start
                worker.run();
            }, -1, false);
        }

        public async List<StreamItem> load_trending(string country_code, Cancellable? cancellable = null) throws Error {
            var msg = new Soup.Message("GET", this.base_url + "/trending?region=" + country_code);
            var stream = yield this.session.send_async(msg, GLib.Priority.DEFAULT, cancellable);

            var parser = new Json.Parser();
            var was_json_parsed = parser.load_from_stream(stream);
            yield stream.close_async();

            if (!was_json_parsed) {
                throw new ApiErrorDomain.JSON_ERROR("Failed to load json");
            }

            var root = parser.get_root();
            var array = root.get_array();

            var result = new List<StreamItem>();

            // Access array elements
            for (var i = 0; i < array.get_length(); i++) {
                var node = array.get_element(i);
                var item = Json.gobject_deserialize (typeof (StreamItem), node) as StreamItem;
	            assert (item != null);

	            result.append (item);
            }

            return result;
        }


        public async Gdk.Texture load_thumbnail(string thumbnail_url, Cancellable? cancellable = null) throws Error {
            SourceFunc callback = load_thumbnail.callback;
            Error? err = null;
            Gdk.Texture? res = null;

            this.pool.add(
                new Worker(() => {
                    try {
                        var msg = new Soup.Message("GET", thumbnail_url);

                        var stream = session.send(msg, cancellable);

                        var pixbuf = new Gdk.Pixbuf.from_stream(stream, cancellable);
                        stream.close(cancellable);

                        res = Gdk.Texture.for_pixbuf(pixbuf);
                    } catch (Error error) {
                        err = error;
                    } finally {
                        Idle.add((owned) callback);
                    }
                })
            );

            yield;

            if (err == null) {
                return res;
            } else {
                throw err;
            };
        }

        private static ApiClient? INSTANCE = null;

        public static ApiClient get_instance() {
            if (INSTANCE == null) {
                try {
                    INSTANCE = new ApiClient("https://pipedapi.kavin.rocks");
                } catch(Error e) {
                    error("failed to get api client : %s", e.message);
                }
            }

            return INSTANCE;
        }
    }
}
