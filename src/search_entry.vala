namespace EMusic {

    public class SearchEntry: Gtk.Box {

        public Gtk.SearchEntry entry;

        public SearchEntry() {
            this.set_size_request(1, 80);

            this.entry = new Gtk.SearchEntry();
            this.entry.set_size_request(300, 1);
            this.entry.set_placeholder_text("Search here...");
            this.set_center_widget(this.entry);
        }
    }
}
