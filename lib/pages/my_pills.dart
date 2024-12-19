import 'package:flutter/material.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';

class MyPillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Pills'),
      ),
      body: Column(
        children: [
          Expanded(
            child: const Center(
              child: Text("Halaman My Pills"),
            ),
          ),
          CustomBottomNavigationBar(),
        ],
      ),
    );
  }
}
