# IDEA 1

require 'amatl'

Amatl::Widget.create do |widget|
  
  background 'bg.png'
  padding 10.pixels
  circle(
        :center => widget.center,
        :radius => (widget.width / 2) - (20 + 10),
        :thickness => 5.pixels,
        :fill_color => Color['red']) do |c|
    line(
          :from => c.center,
          :length => c.radius,
          :angle => 0.degrees,
          :thickness => 4.pixels,
          :color => Color['#4384BD'])
    line(
          :from => c.center,
          :length => c.radius,
          :angle => 0.degrees,
          :thickness => 4.pixels,
          :color => Color['#4384BD'])
          
  end
  
end