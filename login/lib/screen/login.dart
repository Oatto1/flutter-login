// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:login/model/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/screen/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(password: '', email: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Sign in"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(fontSize: 14),
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'enter a valid email address'),
                              EmailValidator(errorText: "Invalid email format")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Password",
                            style: TextStyle(fontSize: 14),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'enter a valid password'),
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password!;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: profile.email,
                                            password: profile.password)
                                        .then((value) {
                                      formKey.currentState?.reset();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return WelcomeScreen();
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.code,
                                        gravity: ToastGravity.CENTER);
                                    // String? message;
                                    // if (e.code == 'email-already-in-use') {
                                    //   message = "Login";
                                    //   Fluttertoast.showToast(
                                    //       msg: message,
                                    //       gravity: ToastGravity.CENTER);
                                    // } else if (e.code == 'weak-password') {
                                    //   message = "weak-password";
                                    //   Fluttertoast.showToast(
                                    //       msg: message,
                                    //       gravity: ToastGravity.CENTER);
                                    // } else {
                                    //   message = e.message;
                                    // }

                                    //print(e.message);
                                    // print(e.code);
                                    // String? message;
                                    // if (e.code == 'email-already-in-use') {
                                    //   message =
                                    //       "This email is already in the system. Please use a different email address.";
                                    //   Fluttertoast.showToast(
                                    //       msg: message,
                                    //       gravity: ToastGravity.CENTER);
                                    // } else if (e.code == 'weak-password') {
                                    //   message =
                                    //       "Password must be at least 6 characters long.";
                                    //   Fluttertoast.showToast(
                                    //       msg: message,
                                    //       gravity: ToastGravity.CENTER);
                                    // } else {
                                    //   message = e.message;
                                    // }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
