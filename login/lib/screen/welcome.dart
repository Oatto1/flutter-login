// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/screen/home.dart';

class WelcomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register/Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50, 140, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/LOGO.png",
                  width: 300,
                ),
                ElevatedButton(
                    child: const Text("Log out"),
                    onPressed: () {
                      auth.signOut().then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Homescreen();
                        }));
                      });
                    })
              ],
            ),
          ),
        ));
  }
}
