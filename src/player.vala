namespace EMusic {

    public class AudioBin: Gst.Pipeline{

        public AudioBin() {
            Gst.Element convert = Gst.ElementFactory.make("audioconvert", "convert");
            Gst.Element sink = Gst.ElementFactory.make("autoaudiosink", "sink");

            this.add(convert);
            this.add(sink);

            convert.link(sink);

            Gst.GhostPad ghost_pad = new Gst.GhostPad("sink", convert.get_static_pad("sink"));
            ghost_pad.set_target(convert.get_static_pad("sink"));
            this.add_pad(ghost_pad);
        }
    }

    public class Player: GLib.Object {

        public signal void started();
        public signal void finished();
        public signal void error();

        public string uri;

        public bool playing = false;

        public Gst.Element player;
        public Gst.Element fakesink;

        public EMusic.SongsMonitor monitor;
        public EMusic.AudioBin audio_bin;

        public Player(EMusic.SongsMonitor monitor) {
            this.monitor = monitor;

            this.player = Gst.ElementFactory.make("playbin", "player");
            this.player.set_property("audio-sink", this.audio_bin);

            Gst.Bus bus = this.player.get_bus();
            bus.add_watch(100, this.message_cb);

            /*
            this.fakesink = Gst.ElementFactory.make("fakesink", "fakesink");
            this.player.set_property("video-sink", this.fakesink);
            Gst.Bus bus = this.player.get_bus();
            //bus.add_signal_watch_full()
            bus.message.connect(this.message_cb);
            //this.player.connect("about-to-finish",  self.on_finished)
            */
        }

        private bool message_cb(Gst.Bus bus, Gst.Message message) {
            switch (message.type) {
                case Gst.MessageType.EOS:
		            this.player.set_state(Gst.State.NULL);
		            this.playing = false;
		            this.finished();
                    break;

                case Gst.MessageType.ERROR:
                    GLib.Error err;
                    string debug;
                    message.parse_error(out err, out debug);
                    GLib.stdout.printf("Player Error: %s\n", err.message);
                    this.playing = false;
                    this.error();
                    break;
            }

            return true;
        }

        public void set_file(string path) {
            this.uri = path;
            if (!path.has_prefix("file:///")) {
                try {
                    this.uri = Gst.filename_to_uri(uri);
                } catch (GLib.Error error) {
                    this.error();
                    return;
                }
            }

            this.playing = true;

            print("URI: " + this.uri + "\n");

            this.player.set_property("uri", this.uri);
            this.player.set_state(Gst.State.PLAYING);
            this.started();
        }
    }
}
