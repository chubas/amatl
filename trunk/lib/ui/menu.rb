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
# Provides easy way to create menus
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

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