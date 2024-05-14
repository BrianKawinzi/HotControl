import 'package:flutter/material.dart';
import 'package:hot_control/widgets/nav_drawer.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
       appBar: AppBar(
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
    );
  }
}