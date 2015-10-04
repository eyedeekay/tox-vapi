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

    }
  }
}

public static int main(string [] argv) {
  var bot = new ToxVapi.Bot ();
  bot.run ();

  return 0;
}
