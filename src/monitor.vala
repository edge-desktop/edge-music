namespace EMusic {

    public class SongsMonitor: GLib.Object {

        public signal void new_file(string file);
        public signal void file_deleted(string file);

        public string dir;
        public string[] songs;
        public bool monitoring = false;

        public GLib.File file;
        public GLib.FileMonitor monitor;

        public SongsMonitor() {
            this.dir = GLib.Environment.get_user_special_dir(GLib.UserDirectory.MUSIC);
            this.songs = {};

            this.file = GLib.File.new_for_path(this.dir);

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

            switch (event_type) {
                case GLib.FileMonitorEvent.CREATED:
                    this.new_file(file.get_path());
                    break;

                case GLib.FileMonitorEvent.DELETED:
                    this.file_deleted(file.get_path());
                    break;
            }
        }
    }
}
