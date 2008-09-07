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
# Test for showing an icon in system tray
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

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
