import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginWaiterPage extends StatefulWidget {
  const LoginWaiterPage({super.key});

  @override
  State<LoginWaiterPage> createState() => _LoginWaiterPageState();
}

class _LoginWaiterPageState extends State<LoginWaiterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passcodeController = TextEditingController();

  void loginWaiter() async {
    String name = nameController.text;
    String passcode = passcodeController.text;

    QuerySnapshot waiterSnapshot = await FirebaseFirestore.instance
        .collection('waiters')
        .where('name', isEqualTo: name)
        .where('passcode', isEqualTo: passcode)
        .get();

    if (waiterSnapshot.docs.isNotEmpty) {
      var waiterData = waiterSnapshot.docs.first.data();
      Navigator.pushReplacementNamed(context, '/pos', arguments: waiterData);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Login Failed'),
            content: Text('Incorrect name or passcode'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Waiter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: passcodeController,
              decoration: const InputDecoration(labelText: 'Passcode'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginWaiter,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
