// inventory_page.dart
import 'package:flutter/material.dart';
import 'package:hot_control/database/inventory_database.dart';
import 'package:provider/provider.dart';


class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    final inventoryDatabase = Provider.of<InventoryDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: inventoryDatabase.items.isEmpty
          ? const Center(
              child: Text('No inventory items yet'),
            )
          : ListView.builder(
              itemCount: inventoryDatabase.items.length,
              itemBuilder: (context, index) {
                final item = inventoryDatabase.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Selling: KSH ${item.sellingPrice} Quantity: ${item.quantity}'),
                  trailing: Text('Buying: KSH ${item.buyingPrice.toStringAsFixed(2)}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String name = '';
              double buyingPrice = 0.0;
              double sellingPrice = 0.0;
              int quantity = 0;

              return AlertDialog(
                title: const Text('Add New Inventory Item'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) => name = value,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Buying Price',
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) => buyingPrice = double.tryParse(value) ?? 0.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Selling Price',
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) => sellingPrice = double.tryParse(value) ?? 0.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      inventoryDatabase.addItem(name, buyingPrice, sellingPrice, quantity);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text('Add Inventory'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
