import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';

class WelcomePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                profileController.userName.value =
                    profileController.userName.value;
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
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildProfileInputSlide() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            final imagePath = profileController.profileImagePath.value;
            return GestureDetector(
              onTap: () async {
                await profileController.updateProfileImage();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
                child: imagePath.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
              ),
            );
          }),
          const SizedBox(height: 20),
          Obx(() => TextField(
                onChanged: (value) => profileController.updateUserName(value),
                controller: TextEditingController()
                  ..text = profileController.userName.value,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (profileController.userName.value.isNotEmpty) {
                await profileController
                    .updateUserName(profileController.userName.value);
                Get.offAllNamed('/home');
              } else {
                Get.snackbar("Error", "Nama tidak boleh kosong!",
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text("Selesai"),
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
            child: const Text("SKIP"),
          ),
          Obx(() {
            final currentIndex = pageController.hasClients
                ? pageController.page?.round() ?? 0
                : 0;
            return Row(
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
            );
          }),
          TextButton(
            onPressed: () {
              if (pageController.page?.round() == 2) {
                profileController
                    .updateUserName(profileController.userName.value);
                Get.offAllNamed('/home');
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
