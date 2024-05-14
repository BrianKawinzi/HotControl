import 'package:flutter/material.dart';
import 'package:hot_control/database/order_database.dart';
import 'package:hot_control/helper/helper_function.dart';
import 'package:provider/provider.dart';
import 'package:hot_control/models/order_model.dart';



class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  //Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  void initState() {
    Provider.of<OrderDatabase>(context, listen: false).readOrders();

    super.initState();
  }


  //create new order box
  void createNewOrderBox() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("New Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user input -> name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Item Name'),
            ),

            //user input -> store
            TextField(
              controller: storeController,
              decoration: const InputDecoration(hintText: 'Store of Purchase'),
            ),

            //user input -> buying price
            TextField(
              controller: buyingPriceController,
              decoration: const InputDecoration(hintText: 'Buying Price'),
            ),

            //user input -> quantity
            TextField(
              controller: storeController,
              decoration: const InputDecoration(hintText: 'Quantity'),
            ),

            //user input -> state
            TextField(
              controller: storeController,
              decoration: const InputDecoration(hintText: 'State'),
            ),
          ],
        ),

        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _createNewOrderButton(),
        ],
      )
    );
  }




  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: createNewOrderBox,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: ListView.builder(
          itemCount: value.allOrder.length,
          itemBuilder: (context, index) {
            //get individual orders
            Order individualOrders = value.allOrder[index];

            //return list tile UI
            return ListTile(
              title: Text(individualOrders.name),
              trailing: Text(individualOrders.state),
            );
          },
        ),
      ),
    );
  }

  //save button
  Widget _createNewOrderButton() {
    return MaterialButton(
      onPressed: () async {

        //only save if there are values in the textfield
        if (nameController.text.isNotEmpty && storeController.text.isNotEmpty && quantityController.text.isNotEmpty && buyingPriceController.text.isNotEmpty && stateController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);

          //create new order
          Order newOrder = Order(
            name: nameController.text,
            store: stateController.text,
            quantity: convertQuantity(quantityController.text),
            buyingPrice: convertAmount(buyingPriceController.text),
            state: stateController.text,
            date: DateTime.now(),
          );

          //save to db
          await context.read<OrderDatabase>().createNewOrder(newOrder);

          //clear controllers
          nameController.clear();
          stateController.clear();
          quantityController.clear();
          buyingPriceController.clear();
          stateController.clear();
        }

      },

      child: const Text('Save'),
      
    );
  }

  //cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        //pop box
        Navigator.pop(context);

        //clear controllers
        nameController.clear();
        storeController.clear();
        buyingPriceController.clear();
        quantityController.clear();
        stateController.clear();
      },
      child: const Text('Cancel'),
    );
  }
}