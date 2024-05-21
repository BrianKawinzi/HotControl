import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hot_control/multi_pages/bottom_multi.dart';

class DeptReg extends StatefulWidget {
  const DeptReg({super.key});

  @override
  State<DeptReg> createState() => _DeptRegState();
}

class _DeptRegState extends State<DeptReg> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> departments = [];

  //add departments method
  void _addDepartment(String name, String operator) {
    setState(() {
      departments.add({'name': name, 'operator': operator});
    });
  }

  //save departments method
  void _saveDepartments() async {
    for (var department in departments) {
      await _firestore.collection('departments').add(department);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const BottomMulti();
    }));
  }

  Future<void> _showAddDepartmentDialog() async {
    final _nameController  = TextEditingController();
    final _operatorController = TextEditingController();

    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Department'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Department Name'),
              ),

              TextField(
                controller: _operatorController,
                decoration: const InputDecoration(labelText: 'Department Operator'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
             child: const Text('Cancel'),
             onPressed: () {
              Navigator.of(context).pop();
             },
            ),

            TextButton(
             child: const Text('Add'),
             onPressed: () {
              _addDepartment(_nameController.text, _operatorController.text);
              Navigator.of(context).pop();
             },
            ),
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Multi-Outlet Registration'),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(departments[index]['name']!),
            subtitle: Text(departments[index]['operator']!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDepartmentDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveDepartments,
          child: const Text('Confirm Departments'),
        ),
      ),
    );
  }
}