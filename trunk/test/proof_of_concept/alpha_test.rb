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
# Alpha testing. If alpha support, a semi-transparent blue circle should be drawn
#
# Author::    Ruben Medellin  (mailto:<ruben.medellin.c@gmail.com>)
# Copyright:: Copyright (c) 2008
# License::   GPL v2.0

require 'gtk2'

$alpha_support = false

def initialize_alpha_support(window)
  screen = window.screen
  colormap = screen.rgba_colormap
  if colormap
    puts "Alpha supported!"
    $alpha_support = true
    window.colormap = colormap
  else
    puts "No alpha support..."
    $alpha_support = false
    window.colormap = window.screen.rgb_colormap
  end
end

# No need to be POPUP, set decorated to false to be managed by parent window
# window = Gtk::Window.new(Gtk::Window::POPUP)

window = Gtk::Window.new
window.skip_taskbar_hint = true
window.skip_pager_hint = true
window.app_paintable = true
window.decorated = false

window.signal_connect('expose-event') do |w, e|
  cr = w.window.create_cairo_context
  if $alpha_support
    cr.set_source_rgba(1.0, 1.0, 1.0, 0.0)
  else
    cr.set_source_rgb(1.0, 1.0, 1.0)
  end
  cr.set_operator(Cairo::OPERATOR_SOURCE)
  cr.paint
  width, height = w.size
  cr.set_source_rgba(0.0, 0.4, 0.7, 0.8)
  radius = ([width, height].min).to_f / 2 - 0.8
  cr.arc(width.to_f / 2, height.to_f / 2, radius, 0, 2.0 * 3.14)
  cr.fill
  cr.stroke
end

initialize_alpha_support(window)
window.show_all

Gtk.main