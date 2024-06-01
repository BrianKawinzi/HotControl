import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class POSMulti extends StatefulWidget {
  const POSMulti({Key? key}) : super(key: key);

  @override
  _POSMultiState createState() => _POSMultiState();
}

class _POSMultiState extends State<POSMulti> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> cart = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _getMenuItems();
  }

  Future<void> _getMenuItems() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('menu_items').get();

    setState(() {
      menuItems = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'price': doc['price'],
        };
      }).toList();
    });
  }

  void addToCart(Map<String, dynamic> menuItem) {
    setState(() {
      cart.add(menuItem);
      total += menuItem['price'];
    });
  }

  void removeFromCart(Map<String, dynamic> menuItem) {
    setState(() {
      cart.remove(menuItem);
      total -= menuItem['price'];
    });
  }

  void _createOrder() async {
    final newOrder = {
      'orderId': Random().nextInt(100000).toString(),
      'items': cart,
      'total': total,
      'status': 'pending',
      'timestamp': Timestamp.now(),  // Add a timestamp field to record when the sale was made
    };

    // Add the order to the 'orders' collection
    await _firestore.collection('orders').add(newOrder);

    // Add the sale to the 'sales-history' collection
    await _firestore.collection('sales-history').add(newOrder);

    setState(() {
      cart.clear();
      total = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales Completed Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Page'),
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems[index];
                return ListTile(
                  title: Text(menuItem['name']),
                  subtitle: Text('Ksh${menuItem['price']}'),
                  trailing: ElevatedButton(
                    onPressed: () => addToCart(menuItem),
                    child: const Text('Add'),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Text(
            'Cart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];
                return ListTile(
                  title: Text(cartItem['name']),
                  subtitle: Text('Ksh${cartItem['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => removeFromCart(cartItem),
                  ),
                );
              },
            ),
          ),
          Text('Total: Ksh$total'),
          ElevatedButton(
            onPressed: cart.isEmpty ? null : _createOrder,
            child: const Text('Complete Sale'),
          ),
        ],
      ),
    );
  }
}
