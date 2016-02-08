namespace EMusic {

    public class DetailsBox: Gtk.Box {

        public Gtk.Image image;
        public Gtk.Adjustment adjustment;
        public Gtk.Scale scale;

        public DetailsBox() {
            this.set_orientation(Gtk.Orientation.VERTICAL);

            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.pack_start(box, true, true, 0);

            this.image = EMusic.make_image("image-x-generic-symbolic", 256);
            box.pack_start(this.image, false, false, 0);

            this.adjustment = new Gtk.Adjustment(0, 0, 100, 1, 10, 1);
            this.scale = new Gtk.Scale(Gtk.Orientation.HORIZONTAL, this.adjustment);
            this.scale.set_margin_start(40);
            this.scale.set_margin_end(40);
            this.pack_end(this.scale, false, false, 0);
        }
    }

    public class Controls: Gtk.Box {

        public signal void toggle_play_pause();
        public signal void previous();
        public signal void next();

        public string song_name;
        public string album_name;

        public Gtk.Box center_box;
        public Gtk.Label name_label;
        public Gtk.Button previous_button;
        public Gtk.Button play_button;
        public Gtk.Button next_button;
        public Gtk.Button show_more_button;
        public Gtk.Revealer revealer;

        public EMusic.DetailsBox details_box;

        public Controls() {
            this.set_size_request(1, 50);
            this.set_border_width(10);
            this.set_orientation(Gtk.Orientation.VERTICAL);

            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.pack_start(box, false, false, 0);

            this.center_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            box.set_center_widget(this.center_box);

            this.name_label = new Gtk.Label(null);
            box.pack_start(this.name_label, false, false, 0);

            this.previous_button = new Gtk.Button();
            this.previous_button.set_image(EMusic.make_image("media-skip-backward-symbolic", 50));
            this.previous_button.clicked.connect(() => { this.previous(); });
            this.center_box.pack_start(this.previous_button, false, false, 0);

            this.play_button = new Gtk.Button();
            this.play_button.set_image(EMusic.make_image("media-playback-start-symbolic", 50));
            this.play_button.clicked.connect(() => { this.toggle_play_pause(); });
            this.center_box.pack_start(this.play_button, false, false, 0);

            this.next_button = new Gtk.Button();
            this.next_button.set_image(EMusic.make_image("media-skip-forward-symbolic", 50));
            this.next_button.clicked.connect(() => { this.next(); });
            this.center_box.pack_start(this.next_button, false, false, 0);

            this.show_more_button = new Gtk.Button();
            this.show_more_button.set_image(EMusic.make_image("go-up-symbolic", 50));
            this.show_more_button.clicked.connect(() => { this.show_more(); });
            box.pack_end(this.show_more_button, false, false, 0);

            this.revealer = new Gtk.Revealer();
            this.pack_end(this.revealer, false, false, 0);

            this.details_box = new EMusic.DetailsBox();
            this.revealer.add(this.details_box);
        }

        private void update_name_label() {
            string text = "";
            if (this.song_name != null && this.album_name != null) {
                text = this.revealer.get_child_revealed()? "": "<big>%s</big>\n%s".printf(this.song_name, this.album_name);
            }
            this.name_label.set_markup(text);
        }

        public void set_song_name(string name, string album) {
            this.song_name = name;
            this.album_name = album;
            this.update_name_label();
        }

        public void show_more() {
            this.revealer.set_reveal_child(!this.revealer.get_child_revealed());
            string name = this.revealer.get_child_revealed()? "go-up-symbolic": "go-down-symbolic";
            this.show_more_button.set_image(EMusic.make_image(name, 50));
            this.update_name_label();
        }
    }
}
