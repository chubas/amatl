#!/usr/bin/ruby

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