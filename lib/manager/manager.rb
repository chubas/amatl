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
# Widget manager
# TODO: Add description
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

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