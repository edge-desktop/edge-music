namespace EMusic {

    public class HeaderBar: Gtk.HeaderBar {

        public HeaderBar(Gtk.StackSwitcher switcher) {
            this.set_custom_title(switcher);
            this.set_show_close_button(true);

            Gtk.Button button = new Gtk.Button();
            button.set_image(EMusic.make_image("view-list-symbolic", 24));
            button.set_tooltip_text("What should do this button?");
            this.pack_start(button);
        }
    }
}
