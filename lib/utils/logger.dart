import 'dart:convert' show JsonEncoder;
import 'package:logger/logger.dart'
    show Logger, AnsiColor, Level, LogEvent, LogPrinter;

/// Singleton instance of a logger that can be used across the application
final logger = _createLogger();

Logger _createLogger() {
  return Logger(printer: _Printer());
}

class _Printer extends LogPrinter {
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  @override
  List<String> log(LogEvent event) {
    String messageStr = _stringifyMessage(event.message);
    String errorStr = event.error ?? '';
    AnsiColor color = levelColors[event.level] ?? AnsiColor.none();
    String label = _labelFor(event.level);
    return [color('$label$messageStr$errorStr')];
  }

  String _labelFor(Level level) {
    switch (level) {
      case Level.error:
        return '[!] ERROR: ';
      case Level.warning:
        return '[!] Warning: ';
      default:
        return '';
    }
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
