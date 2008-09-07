require 'gtk2'
require 'ui/menu'
# require daemons
require 'singleton'

module Amatl
  
  class Manager
    
    include Singleton
    
    attr_reader :active_windows
    
    def initialize
      #Register process
      #Start GTK
      
      @active_windows = []
      
      pixbuf = Gdk::Pixbuf.new(
        File.join( $AMATL_ROOT, '..', 'resources', 'amatl_logo.png')
      )
      icon = Gtk::StatusIcon.new
      #TODO: Change icon
      icon.pixbuf = pixbuf
      
      0.upto(1) do |i|
        w = Gtk::Window.new
        w.add(Gtk::Label.new("Window #{i}"))
        w.show_all
        @active_windows << w
      end

      main_menu = Amatl::Menu.make do |menu|
        menu.item("Show time") do |item|
          puts "Hello from #{item} at #{Time.now}"
        end
        menu.submenu("Submenu test") do |submenu|
          submenu.item("Yay!"){ puts "YAY!" }
        end
        menu.submenu("Active windows") do |submenu|
          @active_windows.each_with_index do |w, i|
            submenu.item("Window #{i}") do |menuitem|
              puts "Bye #{w}"
              @active_windows.delete(w)
              w.destroy
              menuitem.destroy
            end
          end
        end
        menu.item("Quit"){ Gtk.main_quit }
      end
      main_menu.show_all

      icon.signal_connect('popup-menu') do |widget, button, activate_time|
        main_menu.menu.popup(nil, nil, button, activate_time)
      end

      #TODO Goes in daemon
      fork do
        Gtk.main
      end
    end
    
  end
  
end