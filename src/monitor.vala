namespace EMusic {

    public class SongsMonitor: GLib.Object {

        public signal void new_file(string file);
        public signal void file_deleted(string file);

        public string folder;
        public string[] songs;
        public bool monitoring = false;

        public GLib.File file;
        public GLib.FileMonitor monitor;

        public SongsMonitor() {
            this.folder = GLib.Environment.get_user_special_dir(GLib.UserDirectory.MUSIC);
            this.songs = this.get_all_songs();

            this.file = GLib.File.new_for_path(this.folder);

            try {
    		    this.monitor = this.file.monitor_directory(FileMonitorFlags.NONE);
		        this.monitor.changed.connect(this.changed_cb);
    		    this.monitoring = true;
    		} catch (GLib.Error error) {
    		    this.monitoring = false;
    		}
        }

        public void changed_cb(GLib.File file, GLib.File? other_file, GLib.FileMonitorEvent event_type) {
            if (!EMusic.is_an_audio_file(file)) {
                return;
            }

            string[] songs = this.songs;

            switch (event_type) {
                case GLib.FileMonitorEvent.CREATED:
                    songs += file.get_path();
                    this.new_file(file.get_path());
                    break;

                case GLib.FileMonitorEvent.DELETED:
                    string[] _songs = {};
                    foreach (string song in this.songs) {
                        if (song != file.get_path()) {
                            _songs += song;
                        }
                    }

                    songs = _songs;

                    this.file_deleted(file.get_path());
                    break;
            }

            this.songs = songs;
        }

        public string[] get_all_songs() {
            string[] songs = {};
            GLib.File file = GLib.File.new_for_path(this.folder);
            GLib.Cancellable cancellable = new GLib.Cancellable();

            try {
                GLib.FileEnumerator enumerator = file.enumerate_children("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS, cancellable);
	            GLib.FileInfo info = null;

                while (cancellable.is_cancelled() == false && ((info = enumerator.next_file(cancellable)) != null)) {
                    string path = GLib.Path.build_filename(folder, info.get_name());
                    if (EMusic.is_an_audio_file(GLib.File.new_for_path(path))) {
                        songs += path;
                    }
	            }
	        } catch (GLib.Error e) {
	        }

	        return songs;
        }
    }
}
