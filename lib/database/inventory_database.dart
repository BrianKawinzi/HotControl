import 'package:flutter/material.dart';
import 'package:hot_control/models/inventory_model.dart';

class InventoryDatabase with ChangeNotifier {
  final List<InventoryItem> items = [];

  void addItem(String name, double buyingPrice, double sellingPrice, int quantity) {
    items.add(InventoryItem(
      name: name,
      buyingPrice: buyingPrice,
      sellingPrice: sellingPrice,
      quantity: quantity,
    ));
    notifyListeners();
  }

  void updateQuantity(String name, int change) {
    final item = items.firstWhere((item) => item.name == name);
    item.quantity += change;
    notifyListeners();
  }
}