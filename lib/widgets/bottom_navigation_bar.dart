import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/pages/home_page.dart'; // Pastikan halaman di-import
import 'package:my_theraphy/pages/my_pills.dart';
import 'package:my_theraphy/pages/add_pills.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan index
    switch (index) {
      case 0:
        Get.off(() => HomePage()); // Navigasi ke HomePage
        break;
      case 1:
        Get.to(() => AddPillsPage(mode: 'add')); // Navigasi ke Add Pills Page
        break;
      case 2:
        Get.to(() => MyPillsPage()); // Navigasi ke My Pills Page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      iconSize: 40,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: FloatingActionButton(
              onPressed: () {
                _onItemTapped(1); // Panggil fungsi untuk navigasi ke Add Pills
              },
              backgroundColor: ColorCollections.primaryDarkBlue,
              child: const Icon(
                Icons.add,
                size: 35,
                color: ColorCollections.primaryWhite,
              ),
            ),
          ),
          label: 'Add Pills',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'lib/assets/ic_pills.png',
            width: 40,
            height: 40,
            color: Colors.black,
          ),
          label: 'My Pills',
        ),
      ],
    );
  }
}
