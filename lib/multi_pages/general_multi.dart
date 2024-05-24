import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_control/components/tile.dart';
import 'package:hot_control/multi_pages/bottom_multi.dart';
import 'package:hot_control/multi_pages/general_pages/department_multi.dart';
import 'package:hot_control/multi_pages/general_pages/expense_multi.dart';
import 'package:hot_control/multi_pages/general_pages/inventory_multi.dart';
import 'package:hot_control/multi_pages/general_pages/order_multi.dart';
import 'package:hot_control/multi_pages/general_pages/waiter_multi.dart';
import 'package:hot_control/widgets/nav_drawer.dart';

class GeneralMulti extends StatefulWidget {
  const GeneralMulti({super.key});

  @override
  State<GeneralMulti> createState() => _GeneralMultiState();
}

class _GeneralMultiState extends State<GeneralMulti> {
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
  //navigation method
  void navigateToTile(BuildContext context, String pageTitle) async {
    switch (pageTitle) {
      case 'Inventory':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const InventoryMulti()));
          break;
      case 'Order':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const OrderMulti()));
          break;
      case 'Expense':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ExpenseMulti()));
          break;
      case 'Department':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DepartmentMulti()));
          break;
      case 'Waiter':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WaiterMulti()));
          break;
      default:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BottomMulti()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
        title: Row(
          children: [


            //name retrieved from firebase
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

            }, 
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),

          //help button
          IconButton(
            onPressed: () {

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

      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () => navigateToTile(context, "Inventory"),
            child: buildTile("Inventory", Icons.shopping_bag),
          ),
          GestureDetector(
            onTap: () => navigateToTile(context, "Order"),
            child: buildTile("Orders", Icons.local_shipping),
          ),
          GestureDetector(
            onTap: () => navigateToTile(context, "Expense"),
            child: buildTile("Expenses", Icons.monetization_on_rounded),
          ),
          GestureDetector(
            onTap: () => navigateToTile(context, "Department"),
            child: buildTile("Departments", Icons.store),
          ),
          GestureDetector(
            onTap: () => navigateToTile(context, "Waiter"),
            child: buildTile("Waiters", Icons.person),
          ),

        ],
      ),
    );
  }
}