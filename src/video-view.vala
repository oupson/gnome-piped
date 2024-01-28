using Piped.PipedApi;
using Gst;

namespace Piped {
    [GtkTemplate (ui = "/fr/oupson/Piped/video-view.ui")]
    class VideoView : Gtk.Widget {
        [GtkChild]
        private unowned Gtk.Picture video_container;

        private Pipeline? pipeline = null;

        public VideoView(string stream_id) {
            var api = Piped.PipedApi.ApiClient.get_instance();

            api.get_streams.begin (stream_id, null, (obj, res) => {
                var stream = api.get_streams.end(res);

                this.pipeline = new Pipeline ("video-pipeline");

                var playbin = ElementFactory.make ("playbin", "bin");
                playbin["uri"] = stream.hls;

                var sink = new Gst.Bin("sink");
                var video_sink = ElementFactory.make("gtk4paintablesink", "sink");
                sink.add(video_sink);

                var pad = video_sink.get_static_pad("sink");
                var ghostpad = new GhostPad("sink", pad);
                ghostpad.set_active(true);
                sink.add_pad(ghostpad);

                playbin.set("video-sink", sink);

                Gdk.Paintable? paintable = null;
                video_sink.get("paintable", ref paintable);

                Gdk.GLContext? gl_context = null;
                paintable.get("gl-context", ref gl_context);

                if (gl_context != null) {
                    warning("gl context");
                }

                video_container.set_paintable(paintable);

                pipeline.add_many(playbin);
                pipeline.set_state (Gst.State.PLAYING);
            });
        }

        public VideoView.from_stream_item(StreamItem item) {
            var id_regex = new Regex("\\/watch\\?v=(.+)");
            MatchInfo info;

            // TODO if not match
            id_regex.match(item.url, 0, out info);

            this(info.fetch(1));
        }

        construct {
            this.set_layout_manager (new Gtk.BinLayout ());
        }
    }
}
