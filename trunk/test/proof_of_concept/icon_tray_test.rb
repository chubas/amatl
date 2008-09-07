require 'gtk2'

window = Gtk::Window.new

label = Gtk::Label.new("Testing...")
window.add(label)

icon = Gtk::StatusIcon.new
icon.stock = Gtk::Stock::OK

main_menu = Gtk::Menu.new
quit_menu_item = Gtk::MenuItem.new('Quit')
quit_menu_item.signal_connect('activate') do |quititem|
  puts "Bye..."
  Gtk.main_quit
end

time_menu = Gtk::MenuItem.new("What time is it?")
time_menu.signal_connect('activate') do |timeitem|
  puts "Changing label"
  label.label = "It is #{Time.now}"
end

main_menu.append(quit_menu_item)
main_menu.append(time_menu)

submenu = Gtk::Menu.new
submenu_item1 = Gtk::MenuItem.new("Item 1")
submenu_item2 = Gtk::MenuItem.new("Item 2")
submenu.append(submenu_item1)
submenu.append(submenu_item2)

submenu_trigger = Gtk::MenuItem.new("Submenu")
submenu_trigger.submenu = submenu

main_menu.append(submenu_trigger)

icon.signal_connect('popup-menu') do |widget, button, activate_time|
  puts "Popup"
  main_menu.popup(nil, nil, button, activate_time)
end

icon.signal_connect('activate') do
  puts "Clicked"
end

main_menu.show_all
window.show_all

Gtk.main
