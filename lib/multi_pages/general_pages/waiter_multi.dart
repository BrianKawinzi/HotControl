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
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: passcodeController,
              decoration: const InputDecoration(hintText: '4-Digit Passcode'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedDepartmentId,
              items: departments
                  .map<DropdownMenuItem<String>>((dept) => DropdownMenuItem<String>(
                        value: dept['id'],
                        child: Text(dept['name']),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartmentId = value;
                  selectedDepartmentName = departments.firstWhere((dept) => dept['id'] == value)['name'];
                });
              },
              decoration: const InputDecoration(hintText: 'Department'),
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
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  passcodeController.text.isNotEmpty &&
                  selectedDepartmentId != null) {
                if (index == null) {
                  await _addWaiter(
                    nameController.text,
                    passcodeController.text,
                    selectedDepartmentId!,
                    selectedDepartmentName!,
                  );
                } else {
                  await _editWaiter(
                    index,
                    nameController.text,
                    passcodeController.text,
                    selectedDepartmentId!,
                    selectedDepartmentName!,
                  );
                }
                nameController.clear();
                passcodeController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show login dialog
  void _showLoginDialog(Function onSuccess) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
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
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
                Navigator.pop(context);
                onSuccess();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  _showErrorMessage('User not found');
                } else if (e.code == 'wrong-password') {
                  _showErrorMessage('Wrong password');
                }
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiters'),
      ),
      body: ListView.builder(
        itemCount: waiters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(waiters[index]['name']),
            subtitle: Text('Department: ${waiters[index]['departmentName']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.blue),
                  onPressed: () {
                    _showLoginDialog(() => _showAddWaiterDialog(index: index));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showLoginDialog(() => _deleteWaiter(index));
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWaiterDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
