namespace EMusic {

    public class Window: Gtk.ApplicationWindow {

        public EMusic.Player player;

        public EMusic.App app;
        public EMusic.AlbumsView albums_view;
        public EMusic.ArtistsView artists_view;
        public EMusic.SongsView songs_view;
        public EMusic.HeaderBar headerbar;
        public EMusic.SearchEntry search_entry;
        public EMusic.Controls controls;

        public Gtk.Box box;
        public Gtk.Stack stack;
        public Gtk.StackSwitcher switcher;

        public Window(EMusic.App app) {
            this.app = app;

            this.player = new EMusic.Player();

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            this.search_entry = new EMusic.SearchEntry();
            this.box.pack_start(this.search_entry, false, false, 0);

            this.stack = new Gtk.Stack();
            this.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            this.stack.set_transition_duration(250);
            this.box.pack_start(this.stack, true, true, 0);

            this.switcher = new Gtk.StackSwitcher();
            this.switcher.set_stack(this.stack);

            this.albums_view = new EMusic.AlbumsView();
            this.stack.add_titled(this.albums_view, "AlbumsView", "Albums");

            this.artists_view = new EMusic.ArtistsView();
            this.stack.add_titled(this.artists_view, "ArtistView", "Artists");

            this.songs_view = new EMusic.SongsView();
            this.songs_view.set_entry(this.search_entry);
            this.stack.add_titled(this.songs_view, "SongsView", "Songs");

            this.headerbar = new EMusic.HeaderBar(this.switcher);
            this.set_titlebar(this.headerbar);

            this.controls = new EMusic.Controls();
            this.box.pack_end(this.controls, false, false, 0);

            this.show_all();
        }
    }
}
