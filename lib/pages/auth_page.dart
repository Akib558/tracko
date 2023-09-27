import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracko/focus_page.dart';
import 'package:tracko/home_page.dart';
import 'package:tracko/pages/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _myBox = Hive.box("Tracko_Database");

    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_myBox.get("focus") == 1) {
                return FocusItemListPage();
              }
              return HomePage();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
