import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PosMulti extends StatefulWidget {
  const PosMulti({super.key});

  @override
  State<PosMulti> createState() => _PosMultiState();
}

class _PosMultiState extends State<PosMulti> {
  List<Map<String, dynamic>> inventoryItems = [];
  Map<String, dynamic>? waiterData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    waiterData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (waiterData != null) {
      _getInventoryItems();
    }
  }

  Future<void> _getInventoryItems() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('inventory')
        .where('departmentId', isEqualTo: waiterData!['departmentId'])
        .get();

    setState(() {
      inventoryItems = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS')),
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          var item = inventoryItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: ${item['sp']} Quantity: ${item['quantity']}'),
            onTap: () {
              // Add to cart functionality here
            },
          );
        },
      ),
    );
  }
}
