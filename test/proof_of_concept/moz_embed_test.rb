# --
# Amatl - Desktop widgets for Gnome
# Copyright (C) 2008 Ruben Medellin <ruben.medellin.c@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# --
#
# Simple test for mozembed widgets (rendering of HTML)
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

require 'gtk2'
require 'gtkmozembed'

Gtk.init

window = Gtk::Window.new

vbox = Gtk::VBox.new
vbox.add(Gtk::Label.new("Lol, a label"))
vbox.add(moz = Gtk::MozEmbed.new)
b = Gtk::Button.new("Show")
b.signal_connect("clicked") do
  #moz.open_stream('file:/' + File.expand_path('.', 'templates') + 'base.html', 'text/html')

  html = <<-HTML
    <style type="text/css">
      .cosa {
        font-weight: bold;
        color: #003366;
        background-color: #99CCFF;
      }
    </style>
    <div class="cosa">
      It works!
    </div>
  HTML

  moz.render_data(html, "file://" + Dir.getwd + "/", "text/html")
  #moz.append_data(html)
  #moz.close_stream
end
vbox.add(b)
vbox.add(Gtk::Label.new("Finished!"))

window.add(vbox)

window.show_all
Gtk.main