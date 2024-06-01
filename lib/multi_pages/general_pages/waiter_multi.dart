import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaiterMulti extends StatefulWidget {
  const WaiterMulti({super.key});

  @override
  State<WaiterMulti> createState() => _WaiterMultiState();
}

class _WaiterMultiState extends State<WaiterMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> waiters = [];
  List<Map<String, dynamic>> departments = [];

  @override
  void initState() {
    super.initState();
    _getDeptDetails();
    _getWaiters();
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
          };
        }).toList();
      });
    }
  }

  Future<void> _getWaiters() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('waiters').get();

    setState(() {
      waiters = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'passcode': doc['passcode'],
          'departmentId': doc['departmentId'],
          'departmentName': doc['departmentName'],
        };
      }).toList();
    });
  }

  Future<void> _addWaiter(String name, String passcode, String departmentId, String departmentName) async {
    DocumentReference docRef = await _firestore.collection('waiters').add({
      'name': name,
      'passcode': passcode,
      'departmentId': departmentId,
      'departmentName': departmentName,
    });

    setState(() {
      waiters.add({
        'id': docRef.id,
        'name': name,
        'passcode': passcode,
        'departmentId': departmentId,
        'departmentName': departmentName,
      });
    });
  }

  Future<void> _editWaiter(int index, String name, String passcode, String departmentId, String departmentName) async {
    String waiterId = waiters[index]['id'];
    await _firestore.collection('waiters').doc(waiterId).update({
      'name': name,
      'passcode': passcode,
      'departmentId': departmentId,
      'departmentName': departmentName,
    });

    setState(() {
      waiters[index] = {
        'id': waiterId,
        'name': name,
        'passcode': passcode,
        'departmentId': departmentId,
        'departmentName': departmentName,
      };
    });
  }

  Future<void> _deleteWaiter(int index) async {
    if (waiters[index].containsKey('id')) {
      await _firestore.collection('waiters').doc(waiters[index]['id']).delete();
    }
    setState(() {
      waiters.removeAt(index);
    });
  }

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();
  String? selectedDepartmentId;
  String? selectedDepartmentName;

  // Show add/edit waiter dialog
  void _showAddWaiterDialog({int? index}) {
    if (index != null) {
      nameController.text = waiters[index]['name'];
      passcodeController.text = waiters[index]['passcode'];
      selectedDepartmentId = waiters[index]['departmentId'];
      selectedDepartmentName = waiters[index]['departmentName'];
    } else {
      nameController.clear();
      passcodeController.clear();
      selectedDepartmentId = null;
      selectedDepartmentName = null;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Waiter' : 'Edit Waiter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Waiter Name'),
            ),
            TextField(
              controller: passcodeController,
              decoration: const InputDecoration(hintText: 'Waiter Passcode'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDepartmentId,
              items: departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department['id'],
                  child: Text(department['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartmentId = value;
                  selectedDepartmentName = departments
                      .firstWhere((dept) => dept['id'] == value)['name'];
                });
              },
              decoration: const InputDecoration(hintText: 'Select Department'),
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _saveButton(index),
        ],
      ),
    );
  }

  Widget _saveButton(int? index) {
    return ElevatedButton(
      onPressed: () {
        if (nameController.text.isNotEmpty &&
            passcodeController.text.isNotEmpty &&
            selectedDepartmentId != null) {
          if (index == null) {
            _addWaiter(nameController.text, passcodeController.text,
                selectedDepartmentId!, selectedDepartmentName!);
          } else {
            _editWaiter(
                index,
                nameController.text,
                passcodeController.text,
                selectedDepartmentId!,
                selectedDepartmentName!);
          }
          Navigator.pop(context);
        }
      },
      child: const Text('Save'),
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWaiterDialog();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Waiters',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
      ),
      body: ListView.builder(
        itemCount: waiters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(waiters[index]['name'] ?? ''),
            subtitle: Text('Passcode: ${waiters[index]['passcode']} \nDepartment: ${waiters[index]['departmentName']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _showAddWaiterDialog(index: index);
                  },
                  icon: const Icon(Icons.settings, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _deleteWaiter(index);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
