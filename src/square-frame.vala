namespace Piped {

    class SquareFrame : Gtk.Widget {
        private Gtk.Widget? _child = null;
        public Gtk.Widget? child {
            get {
                return this._child;
            }
            set {
                if (this._child != null) {
                    this._child.unparent();
                }

                this._child = value;

                if (this._child != null) {
                    this._child.set_parent(this);
                }
            }
        }

        ~SquareFrame() {
            this.child = null;
        }

        protected override Gtk.SizeRequestMode get_request_mode() {
            return HEIGHT_FOR_WIDTH;
        }

        protected override void measure(Gtk.Orientation orientation, int for_size, out int minimum, out int natural, out int minimum_baseline, out int natural_baseline) {
            int child_min, child_nat = 0;
            if (this._child != null) {
                this._child.measure(orientation, for_size, out child_min, out child_nat, null, null);
            }
            minimum_baseline = natural_baseline = -1;
            minimum = natural = for_size;
        }

        protected override void size_allocate(int width, int height, int baseline) {
            if (this._child != null) {
                var allocation = Gtk.Allocation() { x = 0, y = 0, width = width, height = height };
                this._child.allocate_size(allocation, baseline);
            }
        }
    }
}
