import 'package:flutter/material.dart';
import 'package:hot_control/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          //logo
          Padding(
            padding: const EdgeInsets.only(
              left: 80.0,
              right: 80,
              bottom: 40,
              top: 160,
            ),
            child: Image.asset('lib/images/logo.png'),
          ),

          //HotControl best automated system for you
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "HotControl best automated system for you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //your software cashbook
          const Text(
            "your software cashbook",
            style: TextStyle(
              color: Color.fromARGB(255, 134, 132, 132)
            ),
          ),


          const Spacer(),

          //get started button
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return RegPage();
              }
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 27, 216, 237),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: const Text(
              "Get Started",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}