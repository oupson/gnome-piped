using Piped.PipedApi;
namespace Piped {
    class StreamItemFactoryUtils {
        static void setup_stream_item(Gtk.SignalListItemFactory factory, Object item) {
            var list_item = item as Gtk.ListItem;
            var image = new Gtk.Picture();
            image.hexpand = true;
            image.set_content_fit(Gtk.ContentFit.COVER);

            var frame = new Piped.SquareFrame();
            frame.child = image;

            var title = new Gtk.Label("");
            title.set_single_line_mode(true);
            title.set_wrap(true);
            title.set_ellipsize(Pango.EllipsizeMode.MIDDLE);

            var uploader_name = new Gtk.Label("");
            uploader_name.add_css_class("dim-label");
            uploader_name.set_single_line_mode(true);
            uploader_name.set_wrap(true);
            uploader_name.set_ellipsize(Pango.EllipsizeMode.MIDDLE);

            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
            box.set_margin_start(2);
            box.set_margin_end(2);
            box.set_margin_bottom(2);
            box.set_margin_top(2);

            var box2 = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

            box.append (frame);
            box.append (box2);

            box2.append (title);
            box2.append (uploader_name);

            list_item.set_data("title", title);
            list_item.set_data("image", image);
            list_item.set_data("uploader_name", uploader_name);

            list_item.set_child(box);
        }

        static void bind_stream_item(Gtk.SignalListItemFactory factory, Object item) {
            var list_item = item as Gtk.ListItem;
            var api_client = Piped.PipedApi.ApiClient.get_instance();

            var stream_item = list_item.get_item () as StreamItem;
            var title = list_item.get_data<Gtk.Label>("title");
            title.label = stream_item.title;

            var image = list_item.get_data<Gtk.Picture>("image");

            var uploader_name = list_item.get_data<Gtk.Label>("uploader_name");
            uploader_name.label = stream_item.uploaderName;

            image.set_paintable(null);

            var cancellable = new Cancellable();
            list_item.set_data("cancel", cancellable);

            api_client.load_thumbnail.begin(stream_item.thumbnail, cancellable, (obj, res) => {
                try {
                    var img = api_client.load_thumbnail.end(res);
                    image.set_paintable(img);
                } catch(Error e) {
                    if (!cancellable.is_cancelled()) {
                        warning("Failed to load thumbnail : %s", e.message);
                    }
                }
            });
        }

        static void unbind_stream_item(Gtk.SignalListItemFactory factory, Object item) {
            var list_item = item as Gtk.ListItem;
            list_item.get_data<Cancellable>("cancel").cancel();
        }

        public static Gtk.SignalListItemFactory get_factory() {
            var factory = new Gtk.SignalListItemFactory ();

            factory.setup.connect (setup_stream_item);
            factory.bind.connect (bind_stream_item);
            factory.unbind.connect(unbind_stream_item);

            return factory;
        }
    }
}
