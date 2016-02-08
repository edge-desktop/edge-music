namespace EMusic {

    public class App: Gtk.Application {

        public GLib.File file;

        public App(string[] args) {
            GLib.Object(application_id: "org.edge.music", flags: GLib.ApplicationFlags.FLAGS_NONE);

            this.file = GLib.File.new_for_commandline_arg(args[0]);
       }

	    protected override void activate() {

	        this.window_removed.connect(this.window_removed_cb);
            this.new_window();
        }

        private void window_removed_cb(Gtk.Application self, Gtk.Window window) {
            if (this.get_windows().length() == 0) {
                this.quit();
            }
        }

        public void new_window() {
            EMusic.Window win = new EMusic.Window(this);
            win.set_application(this);
            this.add_window(win);
        }
    }

}


int main(string[] args) {
    Gst.init(ref args);
    return new EMusic.App(args).run();
}
