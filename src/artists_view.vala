namespace EMusic {

    public class ArtistsView: Gtk.ScrolledWindow {

        public Gtk.FlowBox box;

        public ArtistsView() {
            this.box = new Gtk.FlowBox();
            this.add(this.box);
        }
    }
}
