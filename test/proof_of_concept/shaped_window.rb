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
# Shaped window with a fixed Gtk widget over it
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

require 'gtk2'

class ShapedWindow < Gtk::Window
  include Math
  
  def initialize(image)
    super(Gtk::Window::TOPLEVEL)
    self.set_decorated false
    #self.set_app_paintable true
    
    @pixbuf = Gdk::Pixbuf.new(image)
    @w = @pixbuf.width
    @h = @pixbuf.height
    self.set_default_size(@w, @h)
    
    signal_connect("expose-event") do |w, event|
      cc = self.window.create_cairo_context
      cc.set_source_rgba(1.0, 1.0, 1.0, 0.0)
      cc.operator = Cairo::OPERATOR_SOURCE
      cc.paint
      cc.operator = Cairo::OPERATOR_OVER
      cc.antialias = Cairo::ANTIALIAS_SUBPIXEL
      cc.set_source_pixbuf(@pixbuf)
      cc.paint
      
      #DON'T DO THIS!!!
      #bitmap = Gdk::Pixmap.new(nil, @w, @h, 1)
      #self.shape_combine_mask(bitmap, 0, 0)
      children.each do |child|
        propagate_expose(child, event)
      end
    end
    signal_connect('destroy') {Gtk.main_quit}
    
    screen = self.screen
    colormap = screen.rgba_colormap
    if colormap
      puts "Alpha supported!"
      $alpha_support = true
      self.colormap = colormap
    else
      puts "No alpha support..."
      $alpha_support = false
      self.colormap = window.screen.rgb_colormap
    end
    
  end
end

img = File.expand_path(
  File.join(
    File.dirname(__FILE__), 'images', 'clock_bg.png'
  )
)
shape = ShapedWindow.new(img)

f = Gtk::Fixed.new
f.set_size_request(120, 120)
f.put(Gtk::Button.new("Foobar"), 20, 20)
shape.add(f)

f.show_all
shape.show_all

Gtk::main