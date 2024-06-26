import 'package:flutter/material.dart';

Widget buildTile(String title, IconData iconData) {
  return Container(
    margin: const EdgeInsets.all(6.0),
    padding: const EdgeInsets.all(5.0),
    width: 120.0,
    height: 60.0,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 0, 0, 0),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: 40.0,
        ),
        const SizedBox(height: 10.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}