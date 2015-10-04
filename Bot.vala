using GLib;
using Tox;

namespace ToxVapi {
  public class Bot : Object {
    private const string BOT_NAME = "ValaBot";
    private const string BOT_MOOD = "A simple bot in Vala.";
    private const string GROUP_NAME = "Official ValaTox groupchat - https://github.com/ValaTox/client";

    private Tox.Tox handle;
    private bool is_running = false;
    private bool is_connected = false;

    public Bot () {
      print (
        "Running Toxcore version %u.%u.%u\n",
        Tox.Version.MAJOR,
        Tox.Version.MINOR,
        Tox.Version.PATCH
      );
      this.handle = new Tox.Tox (null, null);
      bootstrap ();
      Timeout.add (handle.iteration_interval (), () => {
        handle.iterate ();
        return Source.CONTINUE;
      });

      var user_name = this.BOT_NAME.data;
      this.handle.self_set_name (user_name, null);

      uint8[] name = new uint8[this.handle.self_get_name_size ()];
      this.handle.self_get_name (name);
      print ("Tox name: %s\n", Tools.bin2nullterm (name));

      uint8[] toxid = new uint8[Tox.ADDRESS_SIZE];
      this.handle.self_get_address (toxid);
      print ("ToxID: %s\n", Tools.bin2hex (toxid));

      // Callbacks.
      this.handle.connection_status_callback (this.on_connection_status);
      this.handle.friend_message_callback (this.on_friend_message);
      this.handle.friend_request_callback (this.on_friend_request);
      this.handle.friend_status_callback (this.on_friend_status);

      new MainLoop ().run ();
    }

    private void bootstrap () {
      this.handle.bootstrap (
        "195.154.119.113",
        33445,
        Tools.hex2bin ("E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354"),
        null
      );
      this.handle.bootstrap (
        "144.76.60.215",
        33445,
        Tools.hex2bin ("04119E835DF3E78BACF0F84235B300546AF8B936F035185E2A8E9E0A67C8924F"),
        null
      );
      this.handle.bootstrap (
        "205.185.116.116",
        33445,
        Tools.hex2bin ("A179B09749AC826FF01F37A9613F6B57118AE014D4196A0E1105A98F93A54702"),
        null
      );
      this.handle.bootstrap (
        "212.71.252.109",
        33445,
        Tools.hex2bin ("C4CEB8C7AC607C6B374E2E782B3C00EA3A63B80D4910B8649CCACDD19F260819"),
        null
      );
    }

    /*
    // Adding a friend
    var friend_toxid = Tools.hex2bin ("TOX ID HERE");
    var message = "Add me plz ?";
    stdout.printf("Sending a friend request to %s: \"%s\"\n", Tools.bin2hex (friend_toxid), message);
    this.handle.friend_add (friend_toxid, Tools.hex2bin (message), null);
    */

    public void on_connection_status (Tox.Tox handle, Tox.ConnectionStatus status) {
      if (status != Tox.ConnectionStatus.NONE) {
        print ("Connected to Tox\n");
      } else {
        print ("Disconnected\n");
      }
    }

    public void on_friend_message (Tox.Tox handle, uint32 friend_number, Tox.MessageType type, uint8[] message) {
      string message_string = (string) message;
      uint8[] result = new uint8[Tox.MAX_NAME_LENGTH];
      this.handle.friend_get_name (friend_number, result, null);
      print ("%s: %s\n", (string) result, message_string);

      switch (message_string) {
        case "help":
          var response = "Hi u', I'm a super simple bot made by SkyzohKey. I run with Vala ! :D";
          this.handle.friend_send_message (friend_number, MessageType.NORMAL, response.data, null);
          break;
      }
    }

    public void on_friend_request (Tox.Tox handle, uint8[] public_key, uint8[] message) {
      public_key.length = Tox.PUBLIC_KEY_SIZE; // Fix an issue with Vala.
      var pkey = Tools.bin2hex (public_key);
      print ("Received a friend request from %s.\n", pkey);
      this.handle.friend_add_norequest (public_key, null);
    }

    public void on_friend_status (Tox.Tox handle, uint32 friend_number, UserStatus status) {
      uint8[] result = new uint8[Tox.MAX_NAME_LENGTH];
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
    requires (bin.length != 0)
    {
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
  new ToxVapi.Bot ();
}
