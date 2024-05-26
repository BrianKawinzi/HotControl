import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_control/multi_pages/bottom_multi.dart';
import 'package:hot_control/pages/authentication_page.dart';


import 'package:hot_control/pages/intro_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const BottomMulti(); //later change to bottom navigation
          }

          //user is not logged in
          else {
            return const AuthenticationPage();
          }
        },
      ),
    );
  }
}