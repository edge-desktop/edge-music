namespace EMusic {

    public class SongsView: Gtk.ScrolledWindow {

        public signal void song_selected(string truck);

        public Gtk.ListStore model;
        public Gtk.TreeView view;

        public SongsView() {
            this.model = new Gtk.ListStore(4, typeof(string), typeof(string), typeof(string), typeof(string));  // Name, Artist, Album, filepath

            this.view = new Gtk.TreeView.with_model(this.model);
            this.view.set_reorderable(true);
            this.view.set_headers_clickable(true);
            this.view.add_events(Gdk.EventMask.BUTTON_RELEASE_MASK);
            this.add(this.view);

		    Gtk.CellRendererText cell = new Gtk.CellRendererText();
		    this.view.insert_column_with_attributes(0, "Name", cell, "text", 0);
		    this.view.insert_column_with_attributes(1, "Artists", cell, "text", 1);
		    this.view.insert_column_with_attributes(2, "Album", cell, "text", 2);

		    this.button_release_event.connect(this.button_release_event_cb);
        }

        private bool button_release_event_cb(Gtk.Widget view, Gdk.EventButton event) {
            Gtk.TreePath path;
            unowned Gtk.TreeViewColumn column;
            int cell_x;
            int cell_y;
            Gtk.TreeIter iter;

            this.view.get_path_at_pos((int)event.x, (int)event.y, out path, out column, out cell_x, out cell_y);
            this.model.get_iter(out iter, path);

            GLib.Value gvalue;
            this.model.get_value(iter, 3, out gvalue);

            this.song_selected(gvalue.dup_string());

            return true;
        }

        public void set_entry(EMusic.SearchEntry entry) {
            this.view.set_search_entry(entry.entry);
        }

        public void add_song(string file) {
            EMusic.TagGetter tags = new EMusic.TagGetter(file);
            Gtk.TreeIter iter;
            this.model.append(out iter);
            this.model.set(iter, 0, tags.song_name, 1, tags.artist_name, 2, tags.album_name, 3, file);
        }

        public void set_songs(string[] files) {
            this.model.clear();
            foreach (string file in files) {
                this.add_song(file);
            }
        }
    }
}
