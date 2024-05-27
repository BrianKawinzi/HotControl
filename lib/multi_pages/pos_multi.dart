import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_control/widgets/nav_drawer.dart';

class PosMulti extends StatefulWidget {
  const PosMulti({super.key});

  @override
  State<PosMulti> createState() => _PosMultiState();
}

class _PosMultiState extends State<PosMulti> {
  List<Map<String, dynamic>> inventoryItems = [];
  Map<String, dynamic>? waiterData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> cart = {};

  late String hotelName = '';

  @override
  void initState() {
    super.initState();
    _getHotelName();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    waiterData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (waiterData != null) {
      _getInventoryItems();
    }
  }

  Future<void> _getHotelName() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('hotels').doc(user.uid).get();
      setState(() {
        hotelName = snapshot.get('hotelName') ?? '';
      });
    }
  }

  Future<void> _getInventoryItems() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('inventory')
        .where('departmentId', isEqualTo: waiterData!['departmentId'])
        .get();

    setState(() {
      inventoryItems = snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['name'] ?? '',
        'sp': doc['sp'] ?? 0,
        'quantity': doc['quantity'] ?? 0,
        'departmentId': doc['departmentId'] ?? '',
      }).toList();
    });
  }

  void _addToCart(String itemId) {
    setState(() {
      cart[itemId] = (cart[itemId] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      if (cart[itemId] != null && cart[itemId]! > 0) {
        cart[itemId] = cart[itemId]! - 1;
        if (cart[itemId] == 0) {
          cart.remove(itemId);
        }
      }
    });
  }

  int _cartItemCount() {
    return cart.values.fold(0, (sum, itemCount) => sum + itemCount);
  }

  void _showCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cart: cart, inventoryItems: inventoryItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
        title: Row(
          children: [
            // Name retrieved from Firebase
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
          // Notification button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          // Help button
          IconButton(
            onPressed: () {},
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
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          var item = inventoryItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: ${item['sp']} Quantity: ${item['quantity']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _removeFromCart(item['id']),
                ),
                Text(cart[item['id']]?.toString() ?? '0'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addToCart(item['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCartPage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  _cartItemCount().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<Map<String, dynamic>> inventoryItems;

  const CartPage({Key? key, required this.cart, required this.inventoryItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartItems = inventoryItems
        .where((item) => cart.containsKey(item['id']))
        .map((item) {
          return {
            ...item,
            'quantity': cart[item['id']],
          };
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: ${item['sp']} Quantity: ${item['quantity']}'),
          );
        },
      ),
    );
  }
}
