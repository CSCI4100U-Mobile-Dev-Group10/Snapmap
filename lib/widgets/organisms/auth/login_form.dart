import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/screens/profile_creation_screen.dart';
import 'package:snapmap/services/email_service.dart';
import 'package:snapmap/services/auth_service.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/logger.dart';
import '../nav_controller.dart';

// login form first page of the application

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountRecovery = TextEditingController();

  String email = '';
  String password = '';
  String username = '';
  String confirmPass = '';
  String errorText = '';
  bool pageFlag = false;
  bool errorExists = false;
  bool redeyeOn = false;

  final users = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                      opacity: 0.4,
                      child: Image.asset('images/login_signup_picture.jpg')),
                  pageFlag
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Welcome To Snapmap!',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(
                                'Enter your information below to start snapping!',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54))
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Welcome Back!',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Login below to see what you missed!',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54))
                          ],
                        ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field needs input';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value.toString();
                },
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: pageFlag,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // check to see if email for sign up is valid
                    if (value == null || value.isEmpty) {
                      return 'This field needs input';
                    } else if (!emailValidator(value)) {
                      return 'Enter valid email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    email = value.toString();
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: !redeyeOn,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      redeyeOn = !redeyeOn;
                      setState(() {});
                    },
                    icon: redeyeOn
                        ? const Icon(Icons.remove_red_eye_outlined)
                        : const Icon(Icons.remove_red_eye),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field needs input';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value.toString();
                },
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: pageFlag,
                child: TextFormField(
                  obscureText: !redeyeOn,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field needs input';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPass = value.toString();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                  visible: errorExists,
                  child: Text(
                    errorText,
                    style: const TextStyle(color: Colors.red),
                  )),
              Visibility(
                visible: !pageFlag,
                child: InkWell(
                  child: const Text("Forgot Password?"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Account Recovery"),
                            content:
                                const Text("Enter email to recover password:"),
                            actions: [
                              TextField(
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                controller: _accountRecovery,
                              ),
                              TextButton(
                                onPressed: () {
                                  return Navigator.pop(
                                      context, _accountRecovery.text);
                                },
                                child: const Text("Send Email"),
                              ),
                            ],
                          );
                        }).then((value) async {
                      var emailAlert = value;
                      // check to see if recovery email is in database
                      // if true send recovery email to address
                      await users
                          .where('email', isEqualTo: emailAlert)
                          .get()
                          .then((emailInstance) async {
                        if (emailInstance.docs.isNotEmpty) {
                          var data = emailInstance.docs.first.data();
                          var id = emailInstance.docs.single.id;
                          sendEmail(
                              username: id,
                              password: data['password'],
                              email: data['email']);
                        } else {
                          logger.i('user does not exist');
                        }
                      }).catchError((e) => logger.e(e));
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 70, right: 70),
                    primary: const Color(0xFF7AB5B0)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (!pageFlag) {
                      // authorize user login
                      var returnValue = await authUser({
                        'username': username,
                        'password': password,
                      });
                      if (returnValue == false) {
                        // if the login fails (user does not exist) or entered wrong password
                        errorText =
                            'login attempt failed email or password is wrong';
                        errorExists = true;
                        setState(() {});
                      } else {
                        errorExists = false;
                        setState(() {});
                        Navigator.pushNamed(context, NavController.routeId);
                      }
                    } else {
                      // add users sign up info to database
                      var returnValue = await signUp({
                        'username': username,
                        'email': email,
                        'password': password,
                        'conPass': confirmPass,
                      });
                      if (returnValue == 'username') {
                        errorExists = true;
                        errorText = 'Username already in use';
                        setState(() {});
                      } else if (returnValue == 'email') {
                        errorExists = true;
                        errorText = 'Email already in use';
                        setState(() {});
                      } else if (returnValue == 'password') {
                        errorText =
                            'Confirmation of password does not match entered password';
                        errorExists = true;
                        setState(() {});
                      } else {
                        errorExists = false;
                        pageFlag = false;
                        setState(() {});
                        Navigator.pushNamed(
                            context, ProfileCreationScreen.routeId);
                      }
                    }
                  }
                },
                child: pageFlag
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text("Sign Up"), Icon(Icons.person)],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text("Login"), Icon(Icons.login)],
                      ),
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(thickness: 1, color: Color(0xFF7AB5B0)),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.all(2),
                    child: const Text('OR',
                        style: TextStyle(color: Color(0xFF7AB5B0))),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  errorExists = false;
                  setState(() {
                    pageFlag = !pageFlag;
                  });
                },
                child: pageFlag
                    ? const Text("Login",
                        style: TextStyle(color: Color(0xFF7AB5B0)))
                    : const Text("Sign Up",
                        style: TextStyle(color: Color(0xFF7AB5B0))),
              )
            ],
          ),
        )
      ],
    );
  }
}
