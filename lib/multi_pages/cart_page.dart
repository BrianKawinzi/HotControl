import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalAmount => widget.cartItems.fold(0, (sum, item) => sum + item['sp'] * item['quantity']);

  void processPayment(String paymentMethod, String? mpesaCode) {
    // Handle payment processing logic here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Payment Method: $paymentMethod\nTotal Amount: $totalAmount'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to POS page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showPaymentDialog() {
    TextEditingController mpesaCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  processPayment('Cash', null);
                },
                child: const Text('Cash'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Mpesa Payment'),
                        content: TextField(
                          controller: mpesaCodeController,
                          decoration: const InputDecoration(labelText: 'Mpesa Code'),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              processPayment('Mpesa', mpesaCodeController.text);
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Mpesa'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          var item = widget.cartItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: ${item['sp']} Quantity: ${item['quantity']}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $totalAmount'),
              ElevatedButton(
                onPressed: showPaymentDialog,
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
