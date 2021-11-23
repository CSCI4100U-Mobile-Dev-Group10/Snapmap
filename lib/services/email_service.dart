import 'dart:convert';
import 'package:http/http.dart' as http;

// this file handles email verification and forgoten password email recovery 

Future sendEmail({
  required String username,
  required String password,
  required String email,
}) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': 'service_smkqfxt',
        'template_id': 'template_v2wk9kt',
        'user_id': 'user_C3Qke9dPwz0OJgOyvnd4I',
        'template_params': {
          'username': username,
          'password': password,
          'send_to': email,
        },
      }));
}

bool emailValidator(String email) {
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}