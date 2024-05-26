import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_control/components/my_button.dart';
import 'package:hot_control/components/normal_tf.dart';
import 'package:hot_control/components/password_tf.dart';
import 'package:hot_control/pages/login_page.dart';

class RegPage extends StatelessWidget {
  RegPage({super.key});

  //controllers
  final hotelnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //firebase Authentication instance
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //register method
  void register(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog(context, 'Passwords do not match');
      return;
    }

    _showLoadingDialog(context);

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if newUser and newUser.user are not null before accessing properties
      if (newUser != null && newUser.user != null) {
        // Save hotel name to Firestore
        await _firestore.collection('hotels').doc(newUser.user!.uid).set({
          'hotelName': hotelnameController.text,
        });

        // Navigate to the outlet screen
        Navigator.of(context).pushNamedAndRemoveUntil('/outlet', (route) => false);
      } else {
        // Handle the case where newUser or newUser.user is null
        print('Error: newUser or newUser.user is null');
      }
    } catch (e) {
      Navigator.pop(context); // Remove loading indicator

      if (e is FirebaseAuthException) {
        String message = 'An unknown error occurred';
        if (e.code == 'email-already-in-use') {
          message = 'The email address is already in use by another account';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid';
        } else if (e.code == 'operation-not-allowed') {
          message = 'Email/password accounts are not enabled';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak';
        } else if (e.code == 'network-request-failed') {
          message = 'Network error, please check your internet connection';
        }
        _showErrorDialog(context, message);
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //welcome to hotelhubb
                const Text(
                  'Welcome to HotelHubb',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 25),
                //hotelname textfield
                NormalTf(
                  controller: hotelnameController, 
                  hintText: "Hotel Name", 
                  obscureText: false
                ),
                const SizedBox(height: 10),
                //email textfield
                NormalTf(
                  controller: emailController, 
                  hintText: 'Email', 
                  obscureText: false
                ),
                const SizedBox(height: 10),
                //password textfield
                PasswordTf(
                  controller: passwordController, 
                  hintText: 'Enter Password'
                ),
                const SizedBox(height: 10),
                //confirm password textfield
                PasswordTf(
                  controller: confirmPasswordController, 
                  hintText: 'Confirm Password'
                ),
                const SizedBox(height: 20),
                //register now button
                MyButton( 
                  onTap: () => register(context), 
                  buttonText: "Register Now"
                ),
                const SizedBox(height: 50),
                //Already a member login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already a Member?',
                    ),
                    const SizedBox(width: 4),
                    TextButton(onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const LogPage();
                        }
                      ));
                    }, child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
