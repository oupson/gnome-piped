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
        private unowned Gtk.GridView grid;

        public Window (Gtk.Application app) {
            Object (application: app);

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
            grid.activate.connect ((pos) =>{
                warning("%ld", pos);
            });
        }
    }
}
