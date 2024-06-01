import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesHistory extends StatefulWidget {
  const SalesHistory({super.key});

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> salesHistory = [];

  @override
  void initState() {
    super.initState();
    _getSalesHistory();
  }

  Future<void> _getSalesHistory() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('sales-history').get();

    setState(() {
      salesHistory = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'orderId': doc['orderId'],
          'total': doc['total'],
          'items': doc['items'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    });
  }

  void _showOrderDetails(List<dynamic> items) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
      ),
      body: ListView.builder(
        itemCount: salesHistory.length,
        itemBuilder: (context, index) {
          final sale = salesHistory[index];
          return ListTile(
            title: Text('Order ID: ${sale['orderId']}'),
            subtitle: Text('Total: Ksh${sale['total']}'),
            onTap: () => _showOrderDetails(sale['items']),
          );
        },
      ),
    );
  }
}
