import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_control/components/my_button.dart';
import 'package:hot_control/components/normal_tf.dart';
import 'package:hot_control/components/password_tf.dart';
import 'package:hot_control/pages/register_page.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  bool isLoading = false;

  // Login method
  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/multi');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'User not found';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      }
      showErrorMessage(message);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage('An unexpected error occurred');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
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
                // Welcome back text
                Text(
                  'Welcome back you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 25),

                // Email textfield
                NormalTf(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfield
                PasswordTf(
                  controller: passwordController,
                  hintText: 'Password',
                ),

                const SizedBox(height: 25),

                // Login button
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(onTap: login, buttonText: "Login"),

                const SizedBox(height: 50),

                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return RegPage();
                        }));
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
