import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpenseMulti extends StatefulWidget {
  const ExpenseMulti({super.key});

  @override
  State<ExpenseMulti> createState() => _ExpenseMultiState();
}

class _ExpenseMultiState extends State<ExpenseMulti> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> expenses = [];
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

  Future<void> _getExpensesForDepartment(String departmentId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('expenses')
        .where('departmentId', isEqualTo: departmentId)
        .get();

    setState(() {
      expenses = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'amount': doc['amount'],
          'departmentId': departmentId,
        };
      }).toList();
    });
  }

  void _addExpense(String name, double amount) {
    setState(() {
      expenses.add({
        'name': name,
        'amount': amount,
        'departmentId': selectedDepartmentId,
      });
    });
  }

  void _saveExpenses() async {
    for (var expense in expenses) {
      if (expense.containsKey('id')) {
        await _firestore.collection('expenses').doc(expense['id']).update(expense);
      } else {
        await _firestore.collection('expenses').add(expense);
      }
    }
    Navigator.pop(context);
  }

  void _deleteExpense(int index) async {
    if (expenses[index].containsKey('id')) {
      await _firestore.collection('expenses').doc(expenses[index]['id']).delete();
    }
    setState(() {
      expenses.removeAt(index);
    });
  }

  void _editExpense(int index, String name, double amount) {
    setState(() {
      expenses[index] = {
        'id': expenses[index]['id'],
        'name': name,
        'amount': amount,
        'departmentId': selectedDepartmentId,
      };
    });
  }

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Show add/edit expense dialog
  void _showAddExpenseDialog({int? index}) {
    if (index != null) {
      nameController.text = expenses[index]['name'];
      amountController.text = expenses[index]['amount'].toString();
    } else {
      nameController.clear();
      amountController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Expense' : 'Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Amount'),
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
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                if (index == null) {
                  _addExpense(
                    nameController.text,
                    double.parse(amountController.text),
                  );
                } else {
                  _editExpense(
                    index,
                    nameController.text,
                    double.parse(amountController.text),
                  );
                }
                nameController.clear();
                amountController.clear();
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
    _getExpensesForDepartment(departmentId);
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
                    expenses = [];
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(selectedDepartmentId == null
            ? 'Departments'
            : 'Expenses for $selectedDepartmentName'),
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
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index]['name']),
                  subtitle: Text('Amount: \$${expenses[index]['amount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.blue),
                        onPressed: () {
                          _showAddExpenseDialog(index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteExpense(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: selectedDepartmentId != null
          ? FloatingActionButton(
              onPressed: () => _showAddExpenseDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
