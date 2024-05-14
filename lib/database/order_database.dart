// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hot_control/models/order_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class OrderDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Order> _allOrders = [];

  //initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([OrderSchema], directory: dir.path);
  }

  //getter methods
  List<Order> get allOrder => _allOrders;

  //CRUD Operations

  //Create
  Future<void> createNewOrder(Order newOrder) async {
    //add to db
    await isar.writeTxn(() => isar.orders.put(newOrder));

    //re-read from db
    await readOrders();
  }

  //Read
  Future<void> readOrders() async {
    //fetch all existing orders from db
    List<Order> fetchedOrders = await isar.orders.where().findAll();

    //give to local orders list
    _allOrders.clear();
    _allOrders.addAll(fetchedOrders);

    //update UI
    notifyListeners();
  }
  

  //update
  Future<void> updateOrders(int id, Order updatedOrder) async {
    //ensure id match
    updatedOrder.id = id;

    //update in db
    await isar.writeTxn(() => isar.orders.put(updatedOrder));

    //re-read from db
    await readOrders();
  }

  //delete
  Future<void> deleteOrders(int id) async {
    //delete from db
    await isar.writeTxn(() => isar.orders.delete(id));

    //re-read from db
    await readOrders();
  }
}