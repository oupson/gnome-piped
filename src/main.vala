/* main.vala
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

int main (string[] args) {
    var app = new Piped.Application ();

    #if PIPED_IN_FLATPAK
        try {
            Gdk.Pixbuf.init_modules("/app/lib/piped/gdk-pixbuf/2.10.0/");
        } catch(Error e) {
            warning("Failed to load pixbuf modules : %s", e.message);
        }
    #endif

    return app.run (args);
}
