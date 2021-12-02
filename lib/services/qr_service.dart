import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';

const String _prepend = 'snapmap//';

/// This is the string generated for qr code for this user
String generateQRCode() {
  User user = UserService.getInstance().getCurrentUser()!;
  return '${_prepend}add/${user.username}';
}

class QrResult {
  String? data;
  late QrOperation operation;
  late String username;

  QrResult(this.data) {
    if (data == null) {
      _setNone();
      return;
    }

    if (data!.startsWith(_prepend)) {
      List<String> parts = data!.replaceFirst(_prepend, '').split('/');
      switch (parts[0]) {
        case 'add':
          operation = QrOperation.add;
          username = parts[1];
          break;
        default:
          _setNone();
      }
    }
  }

  void _setNone() {
    operation = QrOperation.none;
    username = '';
  }
}

enum QrOperation { add, none }
