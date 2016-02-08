namespace EMusic {

    public class Player: GLib.Object {

        public signal void started();
        public signal void finished();
        public signal void error();

        public string uri;

        public bool playing = false;

        public Gst.Element player;
        public Gst.Element fakesink;

        public Player() {
            this.player = Gst.ElementFactory.make("playbin", "player");
            this.fakesink = Gst.ElementFactory.make("fakesink", "fakesink");
            this.player.set_property("video-sink", this.fakesink);
            Gst.Bus bus = this.player.get_bus();
            //bus.add_signal_watch_full()
            bus.message.connect(this.message_cb);
            //this.player.connect("about-to-finish",  self.on_finished)
        }

        private void message_cb(Gst.Bus bus, Gst.Message message) {
            switch (message.type) {
                case Gst.MessageType.EOS:
		            this.player.set_state(Gst.State.NULL);
		            this.playing = false;
		            this.finished();
                    break;

                case Gst.MessageType.ERROR:
                    this.playing = false;
                    this.error();
                    break;
            }
        }

        public void set_file(string path) {
            this.uri = path;
            if (path.has_prefix("file:///")) {
                try {
                    this.uri = Gst.filename_to_uri(uri);
                } catch (GLib.Error error) {
                    this.error();
                    return;
                }
            }

            this.playing = true;

            this.player.set_property("uri", this.uri);
            this.player.set_state(Gst.State.PLAYING);
            this.started();
        }
    }
}
