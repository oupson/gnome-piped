/* window.vala
 *
 * Copyright 2023 Unknown
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Soup;
using Piped.PipedApi;

namespace Piped {
    [GtkTemplate (ui = "/fr/oupson/Piped/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.Box child;

        public Window (Gtk.Application app) {
            Object (application: app);

            var grid = new Piped.VideoGrid();
            grid.set_parent(child);

            grid.on_item_clicked.connect (on_video_selected);
        }

        private void on_video_selected(StreamItem item) {
            child.get_first_child().unparent();
            var video_view = new Piped.VideoView.from_stream_item(item);
            video_view.set_parent(child);
        }
    }
}
