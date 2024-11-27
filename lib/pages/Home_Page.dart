import 'package:flutter/material.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: ColorCollections.primaryGray,
                shape: BoxShape.circle,
                // image: DecorationImage(
                //   image: AssetImage('assets/images/profile.png'),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Text(
                  "Hi, ",
                  style: TypographyCollection.sh1,
                ),
                Text(
                  "Zaki",
                  style: TypographyCollection.h1,
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List Tanggal
          Container(
            margin: const EdgeInsets.only(top: 18),
            color: Colors.grey,
            height: 200,
            width: double.infinity,
          ),
          // List Obat untuk diminum
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Obat Hari Ini', style: TypographyCollection.h1),
          ),
          Expanded(
            child: Center(
                child: Text(
              "Belum ada obat",
              style: TypographyCollection.h2,
            )),
          ),
          const CustomBottomNavigationBar(),
        ],
      ),
    );
  }
}
