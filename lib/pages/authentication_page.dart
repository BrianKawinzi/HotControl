import 'package:flutter/material.dart';


class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              }, 
              child: const Text('Register Hotel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              }, 
              child: const Text('Login Hotel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/waitLog');
              }, 
              child: const Text('Login Waiter'),
            ),
          ],
        ),
      ),
    );
  }
}