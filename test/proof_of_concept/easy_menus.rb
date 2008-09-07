require 'gtk2'

module Amatl
  
  class Menu
    attr_accessor :menu
    
    def self.make
      m = Amatl::Menu.new
      yield m
      return m.menu
    end
    
    def item(label, &block)
      i = Gtk::MenuItem.new(label)
      i.signal_connect('activate', &block)
      @menu.append(i)
      return i
    end
    
    def submenu(label)
      new_menu_trigger = Gtk::MenuItem.new(label)
      new_menu = Amatl::Menu.new
      yield new_menu
      new_menu_trigger.submenu = new_menu.menu
      @menu.append(new_menu_trigger)
      return new_menu.menu
    end
    
    private
    def initialize
      @menu = Gtk::Menu.new
    end    
  end
  
end

icon = Gtk::StatusIcon.new
icon.stock = Gtk::Stock::OK
  
main_menu = Amatl::Menu.make do |menu|
  menu.item("Show time") do |item|
    puts "Hello from #{item} at #{Time.now}"
  end
  menu.item("Say hello"){ puts "Hello" }
  menu.submenu("Submenu test") do |submenu|
    submenu.item("Yay!"){ puts "YAY!" }
    submenu.item("Close"){ Gtk.main_quit }
  end
end
main_menu.show_all

icon.signal_connect('popup-menu') do |widget, button, activate_time|
  main_menu.popup(nil, nil, button, activate_time)
end

Gtk.main