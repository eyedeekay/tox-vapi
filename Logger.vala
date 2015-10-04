using GLib;

namespace ToxVapi {
  public enum LogLevel {
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    FATAL;

    public string to_string () {
      switch(this) {
        case INFO:
          return "INFO";
        case WARNING:
          return "WARN";
        case ERROR:
          return "ERROR";
        case FATAL:
          return "FATAL";
        case DEBUG:
          return "DEBUG";
        default:
          return "UNKOWN";
      }
    }
  }

  public class Logger : Object {
    public static LogLevel displayed_level { get; set; default = LogLevel.DEBUG; }
    public static void log (LogLevel level, string message) {
      if (level < displayed_level) {
        return;
      }
      unowned FileStream s = level < LogLevel.ERROR ? stdout : stderr;
      s.printf ("[%s] %s\n", level.to_string (), message);
    }
  }
}
