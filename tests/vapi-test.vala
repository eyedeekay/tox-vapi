using ToxCore;

namespace vapitest {
  public class App : GLib.Object {
    private Tox handle;

    private string USER_NAME;
    private string USER_MOOD;

    private const string BOOTSTRAP_HOST = "195.154.119.113";
    private const uint16 BOOTSTRAP_PORT = 33445;
    private uint8[] BOOTSTRAP_PUBKEY; // Initialized in construct.

    // Constructor.
    public App () {
      // TODO: Initialize the whole app here.
      this.USER_NAME = "ValaTox User";
      this.USER_MOOD = "Happy to uses ValaTox client!";

      this.BOOTSTRAP_PUBKEY = this.hexstring_to_bin (
        "E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354"
      );

      // Init the Tox handle:
      //this.handle = Tox.create (null, null);
    }

    // Run the test app.
    private void run () {
      //this.init_tox_stuff ();
    }

    // Init our Tox related stuff.
    private void init_tox_stuff () {
      // Set the username.
      this.handle.set_name (USER_NAME);

      // Set the user status.
      this.handle.status = UserStatus.AWAY;

      // Set the user mood. (status message)
      this.handle.set_status_message (USER_MOOD);

      // Bootstrap to the needed node.
      this.handle.bootstrap (
        BOOTSTRAP_HOST,
        BOOTSTRAP_PORT,
        BOOTSTRAP_PUBKEY
      );

      // Iterate the Tox handle.
      this.handle.iterate ();
    }

    // Static main.
    public static int main (string[] args) {
      var app = new App ();
      app.run ();
      return 0;
    }

    // Convert a hexstring to uint8[].
    public uint8[] hexstring_to_bin (string s) {
      uint8[] buf = new uint8[s.length / 2];
      for (int i = 0; i < buf.length; ++i) {
        int b = 0;
        s.substring (2*i, 2).scanf ("%02x", ref b);
        buf[i] = (uint8)b;
      }
      return buf;
    }

    // Convert a uint8[] to string.
    public string bin_to_hexstring (uint8[] bin)
      requires (bin.length != 0)
    {
      StringBuilder b = new StringBuilder ();
      for (int i = 0; i < bin.length; ++i) {
        b.append ("%02X".printf (bin[i]));
      }
      return b.str;
    }

    // Convert a uint8[] to C string null terminated.
    public string uint8_to_nullterm_string (uint8[] data) {
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
  }
}
