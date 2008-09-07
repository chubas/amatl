require 'gtk2'

module Amatl
  
  class Menu
    attr_accessor :menu
    
    def self.make
      m = Amatl::Menu.new
      yield m
      return m
    end
    
    def show_all
      @menu.show_all
    end
    
    def popup(*args)
      @menu.popup(*args)
    end
    
    def item(label, &block)
      i = Gtk::MenuItem.new(label)
      i.signal_connect('activate', &block) if block_given?
      @menu.append(i)
      return i
    end
    
    def submenu(label)
      new_menu_trigger = Gtk::MenuItem.new(label)
      new_menu = Amatl::Menu.new
      yield new_menu
      new_menu_trigger.submenu = new_menu.menu
      @menu.append(new_menu_trigger)
      return new_menu
    end
    
    private
    def initialize
      @menu = Gtk::Menu.new
    end    
  end
  
end