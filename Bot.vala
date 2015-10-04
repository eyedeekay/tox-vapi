using GLib;
using Tox;

namespace ToxVapi {
  public class Bot : Object {
    private const string BOT_NAME = "ValaBot";
    private const string BOT_MOOD = "A simple bot in Vala.";
    private const string GROUP_NAME = "Official ValaTox groupchat - https://github.com/ValaTox/client";

    private bool is_connected = false;

    public void Bot () {}
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
      handle.bootstrap (
        "195.154.119.113",
        33445,
        hex2bin ("E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354"),
        null
      );
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
  }
}

public static int main(string [] argv) {
  var bot = new ToxVapi.Bot ();
  bot.run ();

  return 0;
}
