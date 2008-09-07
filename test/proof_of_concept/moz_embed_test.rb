require 'gtk2'
require 'gtkmozembed'

Gtk.init

window = Gtk::Window.new

vbox = Gtk::VBox.new
vbox.add(Gtk::Label.new("Lol, a label"))
vbox.add(moz = Gtk::MozEmbed.new)
b = Gtk::Button.new("Show")
b.signal_connect("clicked") do
  #moz.open_stream('file:/' + File.expand_path('.', 'templates') + 'base.html', 'text/html')

  html = <<-HTML
    <style type="text/css">
      .cosa {
        font-weight: bold;
        color: #003366;
        background-color: #99CCFF;
      }
    </style>
    <div class="cosa">
      It works!
    </div>
  HTML

  moz.render_data(html, "file://" + Dir.getwd + "/", "text/html")
  #moz.append_data(html)
  #moz.close_stream
end
vbox.add(b)
vbox.add(Gtk::Label.new("Finished!"))

window.add(vbox)

window.show_all
Gtk.main