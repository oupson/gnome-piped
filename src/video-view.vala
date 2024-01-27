using Piped.PipedApi;

namespace Piped {
    [GtkTemplate (ui = "/fr/oupson/Piped/video-view.ui")]
    class VideoView : Gtk.Widget {
        private string videoId;

        public VideoView(string videoId) {
            this.videoId = videoId;
        }
    }
}
