using GLib;
using Tox;

namespace ToxVapi {
  public class Bot : Object {
    private const string BOT_NAME = "ValaBot";
    private const string BOT_MOOD = "A simple bot in Vala.";
    private const string GROUP_NAME = "Official ValaTox groupchat - https://github.com/ValaTox/client";

    private bool is_connected = false;

    public Bot () {}
    public int run () {
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

      var handle = new Tox.Tox (null, null);
      handle.self_set_name (hex2bin("NOOB."), null);

      uint8[] name;
      handle.self_get_name (name);
      stdout.printf("Tox name: %s", bin2hex(name));

      handle.bootstrap (
        "195.154.119.113",
        33445,
        hex2bin ("E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354"),
        null
      );

      handle.friend_message_callback (this.handle_message);
      handle.iterate ();
    }

    public void handle_message (uint32 friend_number, MessageType type, uint8[] message) {
      stdout.printf ("%u: %s".printf (friend_number, bin2hex(message)));
    }

    public uint8[] hex2bin (string s) {
      uint8[] buf = new uint8[s.length / 2];
      for (int i = 0; i < buf.length; ++i) {
        int b = 0;
        s.substring (2*i, 2).scanf ("%02x", ref b);
        buf[i] = (uint8)b;
      }
      return buf;
    }

    public string bin2hex (uint8[] bin)
      requires (bin.length != 0)
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
