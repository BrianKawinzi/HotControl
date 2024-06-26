import 'package:flutter/material.dart';
import 'package:hot_control/multi_pages/pos_multi.dart';
import 'package:hot_control/pages/general_page.dart';
import 'package:hot_control/pages/home_page.dart';

import 'package:hot_control/pages/profile_page.dart';
import 'package:hot_control/pages/report_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const POSMulti(),
    const GeneralPage(),
    const ReportPage(),
    const ProfilePage(),
  ];

  //page controller
  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;

            _pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 132, 126, 119),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: _currentIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(239, 84, 81, 76)),
            label: 'Board'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale, color: _currentIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(239, 84, 81, 76)),
            label: 'POS'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps, color: _currentIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(239, 84, 81, 76)),
            label: 'General'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: _currentIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(239, 84, 81, 76)),
            label: 'Reports'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(239, 84, 81, 76)),
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}