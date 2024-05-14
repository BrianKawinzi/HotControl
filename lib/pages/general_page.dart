import 'package:flutter/material.dart';
import 'package:hot_control/components/tile.dart';
import 'package:hot_control/pages/bottom_nav.dart';
import 'package:hot_control/pages/inventory_page.dart';
import 'package:hot_control/pages/order_page.dart';
import 'package:hot_control/widgets/nav_drawer.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  //function to navigate tile
  void navigateToPage(BuildContext context, String pageTitle) async {
    switch (pageTitle) {
      case 'Orders':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const OrderPage()));
        break;
      case 'Inventory':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const InventoryPage()));
        break;
      default:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BottomNav()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar:  AppBar(
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
        title: const Row(
          children: [

            //Hotel name token will be taken from api
            Padding(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                'Kanini Kaseo Hotel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          //Notification button
          IconButton(
            onPressed: () {

            }, 
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),


          //help button
          IconButton(
            onPressed: () {
              //handle help logic
            },
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),

      drawer: const Drawer(
        child: NavDrawer(),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () => navigateToPage(context, "Orders"),
            child: buildTile("Orders", Icons.local_shipping),
          ),
          GestureDetector(
            onTap: () => navigateToPage(context, "Inventory"),
            child: buildTile("Inventory", Icons.shopping_bag),
          ),
        ],
      ),
    );
  }
}