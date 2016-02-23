namespace EMusic {

    public class AlbumsView: Gtk.ScrolledWindow {

        public Gtk.FlowBox box;

        public AlbumsView() {
            this.box = new Gtk.FlowBox();
            this.add(this.box);
        }

        public void add_song(string file) {
        }
    }
}
