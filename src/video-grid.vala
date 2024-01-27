using Piped.PipedApi;

namespace Piped {
    [GtkTemplate (ui = "/fr/oupson/Piped/video-grid.ui")]
    class VideoGrid : Gtk.Widget {
        public signal void on_item_clicked(StreamItem item);

        [GtkChild]
        private unowned Gtk.GridView grid;

        public VideoGrid() {
            this.set_layout_manager (new Gtk.BinLayout ());
            ListStore list_store = new ListStore(typeof (StreamItem));

            var api_client = Piped.PipedApi.ApiClient.get_instance();
            api_client.load_trending.begin ("US", null, (obj, res) => {
                try {
                    var stream_list = api_client.load_trending.end(res);

                    foreach(var item in stream_list) {
                        list_store.append (item);
                    }
                } catch(Error e) {
                    warning("Failed to load trendings : %s", e.message);
                }
            });

            grid.set_model (new Gtk.NoSelection (list_store));

            var factory = StreamItemFactoryUtils.get_factory();
            grid.set_factory(factory);
            grid.single_click_activate = true;
            grid.activate.connect ((pos) => {
                this.on_item_clicked((StreamItem)list_store.get_item(pos));
            });
        }
    }
}
