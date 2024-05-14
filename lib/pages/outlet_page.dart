import 'package:flutter/material.dart';
import 'package:hot_control/pages/bottom_nav.dart';

class OutletPage extends StatelessWidget {
  const OutletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
        elevation: 10.0,
        title: const Row(
          children: [
            //back button

            //hotel account selection title
            Padding(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                'Hotel Account Selection',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //single outlet card
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      const Text(
                        'Single Outlet Account',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      //subtext
                      const Text(
                        'Experience all the benefits of our hotel account tailored for single outlet establishment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // Add your logic for when the button is pressed
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  const BottomNav();
                            }
                          ),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Background color
                        ),
                        child: const Text(
                          'Select Single Outlet Account',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //multi outlet card
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      const Text(
                        'Multi-Outlet Account',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      //subtext
                      const Text(
                        'Unlock the full potential of our hotel account designed for multi-outlet establishments',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // Add your logic for when the button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Background color
                        ),
                        child: const Text(
                          'Select Multi-Outlet Account',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
