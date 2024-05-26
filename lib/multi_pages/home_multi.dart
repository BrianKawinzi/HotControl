import 'package:flutter/material.dart';
import 'package:hot_control/widgets/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeMulti extends StatefulWidget {
  const HomeMulti({super.key});

  @override
  State<HomeMulti> createState() => _HomeMultiState();
}

class _HomeMultiState extends State<HomeMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String hotelName = '';

  @override
  void initState() {
    super.initState();
    _getHotelName();
  }

  Future<void> _getHotelName() async {
    final User? user = _auth.currentUser;
    if(user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('hotels').doc(user.uid).get();
      setState(() {
        hotelName = snapshot.get('hotelName') ?? '';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
        title: Row(
          children: [

            //hotel name retrieve from firebase
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: Text(
                hotelName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          //notification button
          IconButton(
            onPressed: () {
              //add logic here
            }, 
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),


          //help button
          IconButton(
            onPressed: () {
              //handle help logic
            }, 
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),

      drawer: const Drawer(
        child: NavDrawer(),
      ),
    );
  }
}