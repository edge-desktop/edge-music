namespace EMusic {

    public class TagGetter: GLib.Object {

        public string song_name { get; set; }
        public string album_name { get; set; }
        public string artist_name { get; set; }
        public string duration { get; set; }

        public GLib.File file;

        public TagGetter(string song_file) {
            this.file = GLib.File.new_for_path(song_file);

        }
    }
}
