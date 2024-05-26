import 'package:flutter/material.dart';
import 'package:hot_control/multi_pages/general_multi.dart';
import 'package:hot_control/multi_pages/home_multi.dart';
import 'package:hot_control/multi_pages/pos_multi.dart';
import 'package:hot_control/multi_pages/profile_multi.dart';
import 'package:hot_control/multi_pages/report_multi.dart';

class BottomMulti extends StatefulWidget {
  const BottomMulti({super.key});

  @override
  State<BottomMulti> createState() => _BottomMultiState();
}

class _BottomMultiState extends State<BottomMulti> {
  int _currentIndex = 0;

  final List<Widget>_pages = [
    const HomeMulti(),
    const PosMulti(),
    const GeneralMulti(),
    const ReportMulti(),
    const ProfileMulti(),
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