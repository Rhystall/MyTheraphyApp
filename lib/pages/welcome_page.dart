import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());
  int currentIndex = 0;

  Future<void> saveUserData() async {
    if (nameController.text.isNotEmpty) {
      await profileController.updateUserName(nameController.text);
      await profileController.loadProfileData(); // Pastikan data diperbarui
      Get.offAllNamed('/home'); // Navigasi ke halaman utama
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh kosong!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                buildSlide(
                  title: "Selamat Datang di MyTherapy",
                  description: "Aplikasi yang membantu mengelola kesehatanmu.",
                  imagePath: "lib/assets/images/welcome1.png",
                ),
                buildSlide(
                  title: "Fitur Terbaik untuk Anda",
                  description: "Atur pengingat obat dan pantau kesehatanmu.",
                  imagePath: "lib/assets/images/welcome2.png",
                ),
                buildProfileInputSlide(),
              ],
            ),
          ),
          buildBottomNav(),
        ],
      ),
    );
  }

  Widget buildSlide({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 200),
          const SizedBox(height: 20),
          Text(
            title,
            style: TypographyCollection.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TypographyCollection.h2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildProfileInputSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mulai dengan mengisi nama dan foto profilmu",
            style: TypographyCollection.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: profileController.updateProfileImage,
            child: Obx(() {
              return CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: profileController.profileImagePath.isNotEmpty
                    ? FileImage(File(profileController.profileImagePath.value))
                    : null,
                child: profileController.profileImagePath.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      )
                    : null,
              );
            }),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Nama",
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: saveUserData,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: ColorCollections.primaryDarkBlue,
            ),
            child: const Text(
              "Selesai",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => pageController.jumpToPage(2),
            child: const Text(
              "SKIP",
            ),
          ),
          Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor:
                      currentIndex == index ? Colors.black : Colors.grey,
                ),
              );
            }),
          ),
          TextButton(
            onPressed: () {
              if (currentIndex == 2) {
                saveUserData();
              } else {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Text("NEXT"),
          ),
        ],
      ),
    );
  }
}
