require 'gtk2'

button = Gtk::Button.new
button.signal_connect('clicked') do |*args|
  puts "Hello from button! => #{args}"
end

window = Gtk::Window.new
window.signal_connect('destroy') {
  puts 'Bye!'
  Gtk.main_quit
}
window.border_width = 10
window.add(button)

window.show_all

Gtk.main