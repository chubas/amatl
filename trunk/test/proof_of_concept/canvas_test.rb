require 'gtk2'
require 'gnomecanvas2'

class ClockWindow < Gtk::Window
  
  def initialize(image)
    super
    @pixbuf = Gdk::Pixbuf.new(image)
    @w, @h = @pixbuf.width, @pixbuf.height
    self.set_default_size(@w, @h)
    
    self.decorated = false
    
    @colormap = self.screen.rgba_colormap
    self.colormap = @colormap || window.screen.rgb_colormap
    
    Gtk::Widget.push_colormap(@colormap || window.screen.rgb_colormap)
    @canvas = Gnome::Canvas.new(true)
    Gtk::Widget.pop_colormap
    @canvas.set_size(@w, @h)
    @canvas.set_scroll_region(0, 0, @w, @h)
    @canvas.colormap = @colormap || window.screen.rgb_colormap
    
    @canvas.signal_connect('render-background') do |canvas, buf|
      #puts @canvas.bin_window.class
      cr = canvas.bin_window.create_cairo_context
      if @colormap
        cr.set_source_rgba(1.0, 1.0, 1.0, 0.0)
      else
        cr.set_source_rgb(1.0, 1.0, 1.0)
      end
      #cr.set_operator(Cairo::OPERATOR_SOURCE)
      #cr.paint
      cr.operator = Cairo::OPERATOR_SOURCE
      cr.set_source_pixbuf(@pixbuf)
      cr.paint
      cr.operator = Cairo::OPERATOR_ADD
      #cr.set_source_color(Gdk::Color.new(0xFF, 0x00, 0xFF))
      #puts cr.methods.sort.inspect
      #puts canvas.methods.grep(/color|rgba|alpha|bg/).inspect
      #canvas.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 0, 255))
      #puts canvas.colormap == @colormap
#      canvas.bin_window.invalidate(
#        Gdk::Region.new([[0,0],[250, 200]], Gdk::Region::WINDING_RULE),
#        true
#      )
    end
    #@pixcanvas = Gnome::CanvasPixbuf.new(@canvas.root)
    #@pixcanvas.pixbuf = @pixbuf
    #@pixcanvas.width = 200
    
    add(@canvas)
    
    
    self.signal_connect('expose-event') do |w, event|
      cr = self.window.create_cairo_context
      if @colormap
        cr.set_source_rgba(1.0, 1.0, 1.0, 0.0)
      else
        cr.set_source_rgb(1.0, 1.0, 1.0)
      end
      cr.set_operator(Cairo::OPERATOR_SOURCE)
      cr.paint
      cr.operator = Cairo::OPERATOR_OVER
      cr.antialias = Cairo::ANTIALIAS_SUBPIXEL
      cr.set_source_pixbuf(@pixbuf)
      cr.paint
      puts children
      children.each do |child|
        propagate_expose(child, event)
      end
    end
    
    self.signal_connect('destroy') do
      if @tick
        Gtk::timeout_remove @tick
        @tick = nil
      end
      Gtk.main_quit
    end
    
    setup_clock
    
  end
  
  def center
    [@w / 2, @h / 2]
  end
  
  def hand_line(center, length, val, max)
    angle = (Math::PI * (((val * 360.0) / max) - 90.0)) / 180.0
    px = center[0] + (Math.cos(angle) * length)
    py = center[1] + (Math.sin(angle) * length)
    return [px, py]
  end
  
  def setup_clock
    @seconds_hand = Gnome::CanvasLine.new( @canvas.root,
      :points => [center, hand_line(center, 80, Time.now.sec, 60)],
      :width_pixels => 2,
      :fill_color_rgba => 0x0088FF90
    )
    @minutes_hand = Gnome::CanvasLine.new( @canvas.root,
      :points => [center, hand_line(center, 60, Time.now.min, 60)],
      :width_pixels => 3,
      :fill_color => "green"
    )
    @hours_hand = Gnome::CanvasLine.new( @canvas.root,
      :points => [center, hand_line(center, 50, (Time.now.hour % 12), 12)],
      :width_pixels => 5,
      :fill_color => "red"
    )
    @tick = Gtk::timeout_add(1000) do
      time = Time.now
      secs = time.sec
      @seconds_hand.points = [center, hand_line(center, 80, secs, 60)]
      if secs == 0
        mins = time.min
        @minutes_hand.points = [center, hand_line(center, 60, mins, 60)]
        if mins == 0
          hours = time.hour % 12
          @hours_hand.points = [center, hand_line(center, 50, hours, 12)]
        end
      end
      true
    end
  end
  
end

window = ClockWindow.new(
  File.expand_path(
    File.join(
      File.dirname(__FILE__), 'images', 'clock_bg.png'
    )
  )
)
window.show_all
Gtk.main