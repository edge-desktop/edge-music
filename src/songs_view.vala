namespace EMusic {

    public class SongsView: Gtk.ScrolledWindow {

        public Gtk.ListStore model;
        public Gtk.TreeView view;

        public SongsView() {
            this.model = new Gtk.ListStore(4, typeof(string), typeof(string), typeof(string), typeof(string));  // Name, Artist, Album, filepath

            this.view = new Gtk.TreeView.with_model(this.model);
            this.view.set_reorderable(true);
            this.view.set_headers_clickable(true);
            this.add(this.view);

		    Gtk.CellRendererText cell = new Gtk.CellRendererText();
		    this.view.insert_column_with_attributes(0, "Name", cell, "text", 0);
		    this.view.insert_column_with_attributes(1, "Artists", cell, "text", 1);
		    this.view.insert_column_with_attributes(2, "Album", cell, "text", 2);

		    Gtk.TreeIter iter;
		    this.model.append(out iter);
		    this.model.set(iter, 0, "AAAAAA1", 1, "AAAAAA2", 2, "AAAAAA3");

		    this.model.append(out iter);
		    this.model.set(iter, 0, "BBBBBB1", 1, "BBBBBB2", 2, "BBBBBB3");

		    this.model.append(out iter);
		    this.model.set(iter, 0, "CCCCCCC1", 1, "CCCCCCC2", 2, "CCCCCCC3");
        }

        public void set_entry(EMusic.SearchEntry entry) {
            this.view.set_search_entry(entry.entry);
        }

        public void add_song(string file) {

        }

        public void set_songs(string[] files) {
            this.model.clear();
            foreach (string file in files) {
                this.add_song(file);
            }
        }
    }
}
