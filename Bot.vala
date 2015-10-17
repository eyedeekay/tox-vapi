using ToxCore;

namespace ToxVapi {
    public class Bot : Object {
        private const string BOT_NAME = "RicinBot";
        private const string BOT_MOOD = "A simple bot in Vala - https://github.com/RicinApp/tox-vapi";
        private const string GROUP_NAME = "Official Ricin's groupchat - https://github.com/RicinApp/Ricin";
        private string TOX_SAVE = "Bot.tox";

        private Tox handle;

        private bool connected = false;

        private MainLoop loop = new MainLoop ();

        public Bot () {
            print (
                "Running Toxcore version %u.%u.%u\n",
                ToxCore.Version.MAJOR,
                ToxCore.Version.MINOR,
                ToxCore.Version.PATCH
            );

            var options = new Options (null);
            options.ipv6_enabled = true;
            options.udp_enabled = true;
            options.proxy_type = ProxyType.NONE;

            // Load/Create the Tox_save.
            if (FileUtils.test (this.TOX_SAVE, FileTest.EXISTS)) {
                FileUtils.get_data (this.TOX_SAVE, out options.savedata_data);
                options.savedata_type = SaveDataType.TOX_SAVE;
            }

            this.handle = new Tox (options, null);
            this.bootstrap.begin ();

            this.handle.self_set_name (this.BOT_NAME.data, null);
            this.handle.self_set_status_message (this.BOT_MOOD.data, null);

            uint8[] name = new uint8[this.handle.self_get_name_size ()];
            this.handle.self_get_name (name);
            print ("Tox name: %s\n", Tools.bin2nullterm (name));

            uint8[] toxid = new uint8[ADDRESS_SIZE];
            this.handle.self_get_address (toxid);
            print ("ToxID: %s\n", Tools.bin2hex (toxid));

            // Callbacks.
            this.handle.callback_self_connection_status ((handle, status) => {
                if (status != ConnectionStatus.NONE) {
                    print ("Connected to Tox\n");
                    this.connected = true;
                } else {
                    print ("Disconnected\n");
                    this.connected = false;
                }
            });
            this.handle.callback_friend_message (this.on_friend_message);
            this.handle.callback_friend_request (this.on_friend_request);
            this.handle.callback_friend_status (this.on_friend_status);

            tox_loop ();

            loop.run ();
        }

        void tox_loop () {
          Timeout.add (this.handle.iteration_interval (), () => {
            this.handle.iterate ();
            this.tox_loop ();
            return Source.REMOVE;
          });
        }

        class Server : Object {
            public string owner { get; set; }
            public string region { get; set; }
            public string ipv4 { get; set; }
            public string ipv6 { get; set; }
            public uint64 port { get; set; }
            public string pubkey { get; set; }
        }

        private async void bootstrap () {
            var sess = new Soup.Session ();
            var msg = new Soup.Message ("GET", "https://build.tox.chat/job/nodefile_build_linux_x86_64_release/lastSuccessfulBuild/artifact/Nodefile.json");
            var stream = yield sess.send_async (msg, null);
            var json = new Json.Parser ();
            if (yield json.load_from_stream_async (stream, null)) {
                Server[] servers = {};
                var array = json.get_root ().get_object ().get_array_member ("servers");
                array.foreach_element ((arr, index, node) => {
                    servers += Json.gobject_deserialize (typeof (Server), node) as Server;
                });
                while (!this.connected) {
                    for (int i = 0; i < 4; ++i) { // bootstrap to 4 random nodes
                        int index = Random.int_range (0, servers.length);
                        print ("Bootstrapping to %s:%llu by %s\n", servers[index].ipv4, servers[index].port, servers[index].owner);
                        this.handle.bootstrap (
                            servers[index].ipv4,
                            (uint16) servers[index].port,
                            Tools.hex2bin (servers[index].pubkey),
                            null
                        );
                    }

                    // wait 5 seconds without blocking main loop
                    Timeout.add (5000, () => {
                        bootstrap.callback ();
                        return Source.REMOVE;
                    });
                    yield;
                }
                print ("Done bootstrapping\n");
            }
        }

        /*
        // Adding a friend
        var friend_toxid = Tools.hex2bin ("TOX ID HERE");
        var message = "Add me plz ?";
        stdout.printf("Sending a friend request to %s: \"%s\"\n", Tools.bin2hex (friend_toxid), message);
        this.handle.friend_add (friend_toxid, Tools.hex2bin (message), null);
        */

        public void on_friend_message (Tox handle, uint32 friend_number, MessageType type, uint8[] message) {
            string message_string = (string) message;
            uint8[] result = new uint8[MAX_NAME_LENGTH];
            this.handle.friend_get_name (friend_number, result, null);
            print ("%s: %s\n", (string) result, message_string);

            if (message_string.has_prefix ("add ")) {
                var tox_id = message_string.splice (0, 4);
                var _message = "Add me plz ?";
                print ("Sending a friend request to %s: \"%s\"\n", tox_id, _message);
                uint32 friend_num = this.handle.friend_add (Tools.hex2bin (tox_id), _message.data, null);
                print ("friend_num == %u\n", friend_num);
                return;
            }

            switch (message_string.down ()) {
                case "help":
                    var response_message = "Available commands:\n";
                    response_message += "about - Print informations about the bot.\n";
                    response_message += "delfr - Make the bot delete you from it friend-list.\n";
                    response_message += "save  - Save the .tox profile of the bot. [DEBUG ONLY]\n";
                    response_message += "version - Display the bot version.";

                    this.handle.friend_send_message (friend_number, MessageType.ACTION, response_message.data, null);
                    break;
                case "id":
                    uint8[] toxid = new uint8[ADDRESS_SIZE];
                    this.handle.self_get_address (toxid);
                    var response_message = "My ToxID: " + Tools.bin2hex (toxid);
                    this.handle.friend_send_message (friend_number, MessageType.NORMAL, response_message.data, null);
                    break;
                case "about":
                    var response_message = "Heya %s! I'm a simple bot developped while coding the libtoxcore.vapi file. I was wrote by Benwaffle and SkyzohKey, my two cheers master! Anyway, I don't yet supports groupchats so don't invite me in ; I wont respond. :x".printf ((string) result);
                    this.handle.friend_send_message (friend_number, MessageType.NORMAL, response_message.data, null);
                    break;
                case "save":
                    this.handle.friend_send_message (friend_number, MessageType.ACTION, "is saving it .tox file.".data, null);
                    this.save_data ();
                    break;
                case "delfr":
                    this.handle.friend_send_message (friend_number, MessageType.ACTION, "deleted you. Don't forget to delete it too.".data, null);
                    this.handle.friend_delete (friend_number, null);
                    break;
                case "version":
                    var response_message = "Current version: d02cffe163";
                    this.handle.friend_send_message (friend_number, MessageType.NORMAL, response_message.data, null);
                    break;
                case "quit":
                    this.handle.friend_send_message (friend_number, MessageType.ACTION, "will now quit Tox network.".data, null);
                    loop.quit ();
                    break;
                default:
                    var response_message = "Unknown command. Please type `help` to get started. ^-^";
                    this.handle.friend_send_message (friend_number, MessageType.NORMAL, response_message.data, null);
                    break;
            }
        }

        public void on_friend_request (Tox handle, uint8[] public_key, uint8[] message) {
            public_key.length = PUBLIC_KEY_SIZE; // Fix an issue with Vala.
            var pkey = Tools.bin2hex (public_key);
            var message_string = (string) message;

            print ("Received a friend request from:\n");
            print ("--- %s\n", pkey);
            print ("--- %s\n", message_string);
            this.handle.friend_add_norequest (public_key, null);

            // Save the friend in the .tox file.
            this.save_data ();
        }

        public void on_friend_status (Tox handle, uint32 friend_number, UserStatus status) {
            uint8[] result = new uint8[MAX_NAME_LENGTH];
            var name = this.handle.friend_get_name (friend_number, result, null);
            string _status = "Offline";

            switch (status) {
                case UserStatus.NONE:
                    _status = "Online";
                    break;
                case UserStatus.AWAY:
                    _status = "Away";
                    break;
                case UserStatus.BUSY:
                    _status = "Busy";
                    break;
                default:
                    _status = "Offline";
                    break;
            }

            print ("%s is now %s\n", Tools.bin2nullterm (result), _status);
        }

        public bool save_data () {
            info ("Saving data to " + this.TOX_SAVE);
            uint32 size = this.handle.get_savedata_size ();
            uint8[] buffer = new uint8[size];
            this.handle.get_savedata (buffer);
            return FileUtils.set_data (this.TOX_SAVE, buffer);
        }
    }

    public class Tools {
        public static uint8[] hex2bin (string s) {
            uint8[] buf = new uint8[s.length / 2];
            for (int i = 0; i < buf.length; ++i) {
                int b = 0;
                s.substring (2*i, 2).scanf ("%02x", ref b);
                buf[i] = (uint8)b;
            }
            return buf;
        }
        public static string bin2hex (uint8[] bin)
        requires (bin.length != 0) {
            StringBuilder b = new StringBuilder ();
            for (int i = 0; i < bin.length; ++i) {
                b.append ("%02X".printf (bin[i]));
            }
            return b.str;
        }
        public static string bin2nullterm (uint8[] data) {
            //TODO optimize this
            uint8[] buf = new uint8[data.length + 1];
            Memory.copy (buf, data, data.length);
            string sbuf = (string)buf;

            if (sbuf.validate ()) {
                return sbuf;
            }
            // Extract usable parts of the string
            StringBuilder sb = new StringBuilder ();
            for (unowned string s = sbuf; s.get_char () != 0; s = s.next_char ()) {
                unichar u = s.get_char_validated ();
                if (u != (unichar) (-1)) {
                    sb.append_unichar (u);
                } else {
                    stdout.printf ("Invalid UTF-8 character detected");
                }
            }
            return sb.str;
        }
        public static string arr2str (uint8[] array) {
            uint8[] name = new uint8[array.length + 1];
            GLib.Memory.copy (name, array, sizeof(uint8) * name.length);
            name[array.length] = '\0';
            return ((string) name).to_string ();
        }
    }
}

void main() {
    var bot = new ToxVapi.Bot ();
    bot.save_data (); // always save data on exit
}
