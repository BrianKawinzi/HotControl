import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InventoryMulti extends StatefulWidget {
  const InventoryMulti({super.key});

  @override
  State<InventoryMulti> createState() => _InventoryMultiState();
}

class _InventoryMultiState extends State<InventoryMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> inventory = [];
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

  Future<void> _getInventoryForDepartment(String departmentId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('inventory')
        .where('departmentId', isEqualTo: departmentId)
        .get();

    setState(() {
      inventory = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'bp': doc['bp'],
          'sp': doc['sp'],
          'quantities': doc['quantities'],
          'departmentId': doc['departmentId'],
        };
      }).toList();
    });
  }

  Future<void> _addInventory(String name, double bp, double sp, int quantities) async {
    final docRef = await _firestore.collection('inventory').add({
      'name': name,
      'bp': bp,
      'sp': sp,
      'quantities': quantities,
      'departmentId': selectedDepartmentId,
    });

    setState(() {
      inventory.add({
        'id': docRef.id,
        'name': name,
        'bp': bp,
        'sp': sp,
        'quantities': quantities,
        'departmentId': selectedDepartmentId,
      });
    });
  }

  Future<void> _saveInventory() async {
    for (var item in inventory) {
      if (item.containsKey('id')) {
        await _firestore.collection('inventory').doc(item['id']).update(item);
      } else {
        await _firestore.collection('inventory').add(item);
      }
    }
    Navigator.pop(context);
  }

  Future<void> _deleteInventory(int index) async {
    if (inventory[index].containsKey('id')) {
      await _firestore.collection('inventory').doc(inventory[index]['id']).delete();
    }
    setState(() {
      inventory.removeAt(index);
    });
  }

  void _editInventory(int index, String name, double bp, double sp, int quantities) {
    setState(() {
      inventory[index] = {
        'id': inventory[index]['id'],
        'name': name,
        'bp': bp,
        'sp': sp,
        'quantities': quantities,
        'departmentId': selectedDepartmentId,
      };
    });
  }

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController spController = TextEditingController();
  TextEditingController quantitiesController = TextEditingController();

  // Show add/edit inventory dialog
  void _showAddInventoryDialog({int? index}) {
    if (index != null) {
      nameController.text = inventory[index]['name'];
      bpController.text = inventory[index]['bp'].toString();
      spController.text = inventory[index]['sp'].toString();
      quantitiesController.text = inventory[index]['quantities'].toString();
    } else {
      nameController.clear();
      bpController.clear();
      spController.clear();
      quantitiesController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Inventory' : 'Edit Inventory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
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
            TextField(
              controller: quantitiesController,
              decoration: const InputDecoration(hintText: 'Quantities'),
              keyboardType: TextInputType.number,
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
                  bpController.text.isNotEmpty &&
                  spController.text.isNotEmpty &&
                  quantitiesController.text.isNotEmpty) {
                if (index == null) {
                  _addInventory(
                    nameController.text,
                    double.parse(bpController.text),
                    double.parse(spController.text),
                    int.parse(quantitiesController.text),
                  );
                } else {
                  _editInventory(
                    index,
                    nameController.text,
                    double.parse(bpController.text),
                    double.parse(spController.text),
                    int.parse(quantitiesController.text),
                  );
                }
                nameController.clear();
                bpController.clear();
                spController.clear();
                quantitiesController.clear();
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
    _getInventoryForDepartment(departmentId);
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
                    inventory = [];
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(selectedDepartmentId == null
            ? 'Departments'
            : 'Inventory for $selectedDepartmentName'),
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
              itemCount: inventory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(inventory[index]['name']),
                  subtitle: Text('Quantities: ${inventory[index]['quantities']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.blue),
                        onPressed: () {
                          _showAddInventoryDialog(index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteInventory(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: selectedDepartmentId != null
          ? FloatingActionButton(
              onPressed: () => _showAddInventoryDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
