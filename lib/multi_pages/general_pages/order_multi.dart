import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderMulti extends StatefulWidget {
  const OrderMulti({super.key});

  @override
  State<OrderMulti> createState() => _OrderMultiState();
}

class _OrderMultiState extends State<OrderMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> departments = [];
  String? selectedDepartmentId;
  String? selectedDepartmentName;

  @override
  void initState() {
    super.initState();
    _getDeptDetails();
  }

  Future<void> _getDeptDetails() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('departments').get();

      setState(() {
        departments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'operator': doc['operator'],
          };
        }).toList();
      });
    }
  }

  Future<void> _getOrdersForDepartment(String departmentId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('orders')
        .where('departmentId', isEqualTo: departmentId)
        .get();

    setState(() {
      orders = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'store': doc['store'],
          'bp': doc['bp'],
          'sp': doc['sp'],
          'state': doc['state'],
        };
      }).toList();
    });
  }

  void _addOrders(String name, String store, double bp, double sp, String state) {
    setState(() {
      orders.add({
        'name': name,
        'store': store,
        'bp': bp,
        'sp': sp,
        'state': state,
        'departmentId': selectedDepartmentId,
      });
    });
  }

  void _saveOrders() async {
    for (var order in orders) {
      if (order.containsKey('id')) {
        await _firestore.collection('orders').doc(order['id']).update(order);
      } else {
        await _firestore.collection('orders').add(order);
      }
    }
    Navigator.pop(context);
  }

  void _deleteOrder(int index) async {
    if (orders[index].containsKey('id')) {
      await _firestore.collection('orders').doc(orders[index]['id']).delete();
    }
    setState(() {
      orders.removeAt(index);
    });
  }

  void _editOrder(int index, String name, String store, double bp, double sp, String state) {
    setState(() {
      orders[index] = {
        'id': orders[index]['id'],
        'name': name,
        'store': store,
        'bp': bp,
        'sp': sp,
        'state': state,
        'departmentId': selectedDepartmentId,
      };
    });
  }

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController spController = TextEditingController();
  String selectedState = 'Pending'; // Default value for dropdown

  // Show add/edit order dialog
  void _showAddOrderDialog({int? index}) {
    if (index != null) {
      nameController.text = orders[index]['name'];
      storeController.text = orders[index]['store'];
      bpController.text = orders[index]['bp'].toString();
      spController.text = orders[index]['sp'].toString();
      selectedState = orders[index]['state'];
    } else {
      nameController.clear();
      storeController.clear();
      bpController.clear();
      spController.clear();
      selectedState = 'Pending';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Order' : 'Edit Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: storeController,
              decoration: const InputDecoration(hintText: 'Store'),
            ),
            TextField(
              controller: bpController,
              decoration: const InputDecoration(hintText: 'Buying Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: spController,
              decoration: const InputDecoration(hintText: 'Selling Price'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedState,
              items: ['Pending', 'Complete']
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
              decoration: const InputDecoration(hintText: 'State'),
            ),
          ],
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
              if (nameController.text.isNotEmpty &&
                  storeController.text.isNotEmpty &&
                  bpController.text.isNotEmpty &&
                  spController.text.isNotEmpty &&
                  selectedState.isNotEmpty) {
                if (index == null) {
                  _addOrders(
                    nameController.text,
                    storeController.text,
                    double.parse(bpController.text),
                    double.parse(spController.text),
                    selectedState,
                  );
                } else {
                  _editOrder(
                    index,
                    nameController.text,
                    storeController.text,
                    double.parse(bpController.text),
                    double.parse(spController.text),
                    selectedState,
                  );
                }
                nameController.clear();
                storeController.clear();
                bpController.clear();
                spController.clear();
                setState(() {
                  selectedState = 'Pending'; // Reset dropdown value
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _selectDepartment(String departmentId, String departmentName) {
    setState(() {
      selectedDepartmentId = departmentId;
      selectedDepartmentName = departmentName;
    });
    _getOrdersForDepartment(departmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: selectedDepartmentId != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    selectedDepartmentId = null;
                    selectedDepartmentName = null;
                    orders = [];
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(selectedDepartmentId == null
            ? 'Departments'
            : 'Orders for $selectedDepartmentName'),
      ),
      body: selectedDepartmentId == null
          ? ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(departments[index]['name']),
                  subtitle: Text(departments[index]['operator']),
                  onTap: () => _selectDepartment(
                    departments[index]['id'],
                    departments[index]['name'],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orders[index]['name']),
                  subtitle: Text(orders[index]['state']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.blue),
                        onPressed: () {
                          _showAddOrderDialog(index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteOrder(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: selectedDepartmentId != null
          ? FloatingActionButton(
              onPressed: () => _showAddOrderDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
