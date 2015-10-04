using GLib;
using Tox;

namespace ToxVapi {
  public class Bot : Object {
    private const string BOT_NAME = "ValaBot";
    private const string BOT_MOOD = "A simple bot in Vala.";
    private const string GROUP_NAME = "Official ValaTox groupchat - https://github.com/ValaTox/client";

    private Tox.Tox handle;
    private Thread<int> tox_thread;
    private bool is_running = false;
    private bool is_connected = false;

    public Bot () {}
    public int run () {
      if (!Thread.supported ()) {
        stderr.printf ("Threads are not supported, exiting ...\n");
        return -1;
      }

      stdout.printf("Starting bot...\n");
      this.init_tox ();

      return 0;
    }
    public void init_tox () {
      stdout.printf(
        "Running Toxcore version %u.%u.%u\n",
        Tox.Version.MAJOR,
        Tox.Version.MINOR,
        Tox.Version.PATCH
      );

      this.handle = new Tox.Tox (null, null);
      this.handle.self_set_name (hex2bin("NOOB."), null);

      uint8[] name = new uint8[Tox.MAX_NAME_LENGTH];
      this.handle.self_get_name (name);
      stdout.printf("Tox name: %s\n", bin2hex(name));

      this.handle.bootstrap (
        "195.154.119.113",
        33445,
        hex2bin ("E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354"),
        null
      );

      uint8[] toxid = new uint8[Tox.PUBLIC_KEY_SIZE];
      this.handle.self_get_address (toxid);
      stdout.printf("ToxID: %s\n", bin2hex (toxid));

      this.handle.friend_message (this.handle_message);
      this.launch_thread ();
    }

    public delegate void FriendMessageFunc (
        uint32 friend_number,
        MessageType type,
        uint8[] message
    );

    public void handle_message (uint32 friend_number, MessageType type, uint8[] message) {
      stdout.printf ("%u: %s".printf (friend_number, bin2hex(message)));
    }

    public void launch_thread () {
      this.tox_thread = new Thread<int> ("tox-bg-thread", this.tox_bg_thread);
      int result = this.tox_thread.join ();
    }
    public int tox_bg_thread () {
      this.is_running = true;

      while (this.is_running) {
        lock (this.handle) {
          this.handle.iterate ();
        }

        Thread.usleep (this.handle.iteration_interval () * 1000);
      }

      return 0;
    }


    // Helpers.
    public uint8[] hex2bin (string s) {
      uint8[] buf = new uint8[s.length / 2];
      for (int i = 0; i < buf.length; ++i) {
        int b = 0;
        s.substring (2*i, 2).scanf ("%02x", ref b);
        buf[i] = (uint8)b;
      }
      return buf;
    }
    public string bin2hex (uint8[] bin) requires (bin.length != 0)
    {
      StringBuilder b = new StringBuilder ();
      for (int i = 0; i < bin.length; ++i) {
        b.append ("%02X".printf (bin[i]));
      }
      return b.str;
    }
  }
}

public static int main(string [] argv) {
  var bot = new ToxVapi.Bot ();
  bot.run ();

  return 0;
}
