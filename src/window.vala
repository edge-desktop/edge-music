namespace EMusic {

    public class Window: Gtk.ApplicationWindow {

        public EMusic.App app;
        public EMusic.Player player;
        public EMusic.SongsMonitor monitor;

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

            this.monitor = new EMusic.SongsMonitor();

            this.player = new EMusic.Player(this.monitor);
            this.player.started.connect(this.player_started_cb);
            this.player.finished.connect(this.player_finished_cb);
            this.player.error.connect(this.player_error_cb);

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
            this.songs_view.song_selected.connect(this.song_selected);
            this.stack.add_titled(this.songs_view, "SongsView", "Songs");

            this.headerbar = new EMusic.HeaderBar(this.switcher);
            this.set_titlebar(this.headerbar);

            this.controls = new EMusic.Controls();
            this.box.pack_end(this.controls, false, false, 0);

            foreach (string song in this.monitor.get_all_songs()) {
                this.add_song(song);
            }

            this.show_all();
        }

        private void song_selected(EMusic.SongsView widget, string truck) {
            this.player.set_file(truck);
        }

        private void player_started_cb() {
            print("STARTED\n");
        }

        private void player_finished_cb() {
            print("FINISHED\n");
        }

        private void player_error_cb() {
            print("ERROR\n");
        }

        public void add_song(string song) {
            this.albums_view.add_song(song);
            this.artists_view.add_song(song);
            this.songs_view.add_song(song);
        }
    }
}
