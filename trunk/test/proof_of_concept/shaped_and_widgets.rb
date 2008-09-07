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
# Testing shaped windows with widgets. Works well, except for
# Gtk::MozEmbed widgets, which cannot handle transparency so far
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0require 'gtk2'

require 'gtkmozembed'

$colormap = nil

class ShapedWidgetsWindow < Gtk::Window
  def initialize
    super
    @pixbuf = Gdk::Pixbuf.new( File.expand_path(
      File.join(
        File.dirname(__FILE__), 'images', 'clock_bg.png'
      )))
    @original_pixbuf = @pixbuf
    @w = @pixbuf.width
    @h = @pixbuf.height
    self.set_default_size(@w, @h)
    screen = self.screen
    $colormap = screen.rgba_colormap
    if $colormap
      puts "Alpha supported!"
      $alpha_support = true
      self.colormap = $colormap
    else
      puts "No alpha support..."
      $alpha_support = false
      self.colormap = window.screen.rgb_colormap
    end
    #self.opacity = 0.8
    self.set_decorated(false)
    self.signal_connect('expose-event') do |w, event|
      cr = self.window.create_cairo_context
      if $alpha_support
        cr.set_source_rgba(1.0, 1.0, 1.0, 0.0)
      else
        cr.set_source_rgb(1.0, 1.0, 1.0)
      end
      cr.set_operator(Cairo::OPERATOR_SOURCE)
      cr.paint
      cr.operator = Cairo::OPERATOR_OVER
      cr.antialias = Cairo::ANTIALIAS_SUBPIXEL
      
      # For resizable widgets
      # See Gtk::Window#resizable
      ## x, y = self.size
      ## if @pixbuf.width != x or @pixbuf.height != y
      ##   @pixbuf = @original_pixbuf.scale(x, y)
      ## end
      
      cr.set_source_pixbuf(@pixbuf)
      cr.paint
      children.each do |child|
        propagate_expose(child, event)
      end
    end
    
    
  end
  
end

window = ShapedWidgetsWindow.new
window.signal_connect('destroy'){Gtk.main_quit}
vbox = Gtk::VBox.new
vbox.set_colormap($colormap) if $colormap
#vbox.signal_connect('expose-event') do |box, event|
#  puts box.methods.grep(/ca|co/).inspect
#  cr = box.window.create_cairo_context
#  if $alpha_support
#    cr.set_source_rgba(1.0, 1.0, 0.0, 0.8)
#  else
#    cr.set_source_rgb(1.0, 1.0, 1.0)
#  end
#  cr.set_operator(Cairo::OPERATOR_SOURCE)
#  cr.scale(20, 20)
#  cr.paint
#end

vbox.add(Gtk::Label.new("HELLO WORLD!"))
moz = Gtk::MozEmbed.new
vbox.add(moz)
f = Gtk::Frame.new("Ok, corral")
f.add(b = Gtk::Button.new("Clicke!"))
b.set_size_request(40, 30)
b.signal_connect('clicked') do
  html = <<-HTML
  <html style="background: transparent; border: 2px solid red;">
    <body>
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
   </body>
  </html>
  HTML
  moz.render_data(html, "file://" + Dir.getwd + "/", "text/html")
end
vbox.add(f)

window.add(vbox)
window.show_all

Gtk.main
