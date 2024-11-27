import 'package:flutter/material.dart';
import 'package:my_theraphy/styles/color_collection.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
                  // Add button pressed
                  print('Test jalan ngga');
                },
                backgroundColor: ColorCollections.primaryDarkBlue,
                child: const Icon(Icons.add,
                    size: 35, color: ColorCollections.primaryWhite),
              ),
            ),
            label: 'Add Pills'),
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
