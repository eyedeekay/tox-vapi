using Tox;

namespace vapitest {
  public class App : GLib.Object {
    private Tox.Tox handle;
    private Tox.Options options;

    public App () {
      this.init_tox ();
    }

    private void init_tox () {
      var bootstrap_host = "195.154.119.113";
      var bootstrap_port = 33445;
      var bootstrap_pkey = hexstring_to_bin("E398A69646B8CEACA9F0B84F553726C1C49270558C57DF5F3C368F05A7D71354");

      this.handle = new Tox.Tox (null);
      this.handle.bootstrap (bootstrap_host, bootstrap_port, bootstrap_pkey, null);
      this.handle.wait ();
    }

    public static int main (string[] args) {
      var app = new App ();
      return 0;
    }

    // convert a hexstring to uint8[]
    public static uint8[] hexstring_to_bin(string s) {
      uint8[] buf = new uint8[s.length / 2];
      for(int i = 0; i < buf.length; ++i) {
        int b = 0;
        s.substring(2*i, 2).scanf("%02x", ref b);
        buf[i] = (uint8)b;
      }
      return buf;
    }

    // convert a uint8[] to string
    public static string bin_to_hexstring(uint8[] bin)
      requires(bin.length != 0)
    {
      StringBuilder b = new StringBuilder();
      for(int i = 0; i < bin.length; ++i) {
        b.append("%02X".printf(bin[i]));
      }
      return b.str;
    }

    public static string uint8_to_nullterm_string(uint8[] data) {
      //TODO optimize this
      uint8[] buf = new uint8[data.length + 1];
      Memory.copy(buf, data, data.length);
      string sbuf = (string)buf;

      if(sbuf.validate()) {
        return sbuf;
      }
      // Extract usable parts of the string
      StringBuilder sb = new StringBuilder();
      for (unowned string s = sbuf; s.get_char() != 0; s = s.next_char()) {
        unichar u = s.get_char_validated();
        if (u != (unichar) (-1)) {
          sb.append_unichar(u);
        } else {
          stdout.printf("Invalid UTF-8 character detected");
        }
      }
      return sb.str;
    }
  }
}
