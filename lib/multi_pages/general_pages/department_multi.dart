import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DepartmentMulti extends StatefulWidget {
  const DepartmentMulti({Key? key}) : super(key: key);

  @override
  State<DepartmentMulti> createState() => _DepartmentMultiState();
}

class _DepartmentMultiState extends State<DepartmentMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text controllers
  TextEditingController deptController = TextEditingController();
  TextEditingController opController = TextEditingController();

  List<Map<String, dynamic>> departments = [];

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

  void createNewDept() {
    deptController.clear();
    opController.clear();
    _showDeptDialog();
  }

  void _showDeptDialog({String? id, String? name, String? operator}) {
    if (id != null) {
      deptController.text = name!;
      opController.text = operator!;
    } else {
      deptController.clear();
      opController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? 'Add Department' : 'Edit Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deptController,
              decoration: const InputDecoration(hintText: 'Department'),
            ),
            TextField(
              controller: opController,
              decoration: const InputDecoration(hintText: 'Operator'),
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _saveButton(id),
        ],
      ),
    );
  }

  Widget _saveButton(String? id) {
    return ElevatedButton(
      onPressed: () async {
        if (deptController.text.isNotEmpty && opController.text.isNotEmpty) {
          if (id == null) {
            await _firestore.collection('departments').add({
              'name': deptController.text,
              'operator': opController.text,
            });
          } else {
            await _firestore.collection('departments').doc(id).update({
              'name': deptController.text,
              'operator': opController.text,
            });
          }
          await _getDeptDetails();
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

  void _deleteDept(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: const Text('Are you sure you want to delete this department?'),
        actions: [
          _cancelButton(),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection('departments').doc(id).delete();
              await _getDeptDetails();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewDept,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Departments',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department['name'] ?? ''),
            subtitle: Text(department['operator'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _showDeptDialog(
                      id: department['id'],
                      name: department['name'],
                      operator: department['operator'],
                    );
                  },
                  icon: const Icon(Icons.settings, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _deleteDept(department['id']);
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
