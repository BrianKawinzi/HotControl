import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileMulti extends StatefulWidget {
  const ProfileMulti({Key? key}) : super(key: key);

  @override
  _ProfileMultiState createState() => _ProfileMultiState();
}

class _ProfileMultiState extends State<ProfileMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String hotelName = '';
  late String email = '';
  late String accountType = '';

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('hotels').doc(user.uid).get();

      setState(() {
        hotelName = snapshot.get('hotelName') ?? '';
        email = user.email ?? '';
      });

      _getAccountType(user.uid);
    }
  }

  Future<void> _getAccountType(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('user_selections').doc(userId).get();

    setState(() {
      accountType = snapshot.exists ? 'Multi-Outlet Account' : 'Single Outlet Account';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile'),
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/images/profile.png'), // Add your image here
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    // Add your edit functionality here
                    _showEditDialog();
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            hotelName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            email,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Account Type: $accountType',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog() async {
    // Implement your edit dialog here
  }
}
