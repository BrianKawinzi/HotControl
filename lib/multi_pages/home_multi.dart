import 'package:flutter/material.dart';
import 'package:hot_control/widgets/nav_drawer.dart';

class HomeMulti extends StatelessWidget {
  const HomeMulti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(233, 0, 0, 0),
        elevation: 10.0,
        title: const Row(
          children: [

            //hotel name retrieve from firebase
            Padding(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                'Hotel Name',
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
          //notification button
          IconButton(
            onPressed: () {
              //add logic here
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
    );
  }
}