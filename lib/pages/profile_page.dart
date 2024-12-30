import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return GestureDetector(
                onTap: () => profileController.updateProfileImage(),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: ColorCollections.accentGray,
                  backgroundImage:
                      profileController.profileImagePath.value.isNotEmpty
                          ? FileImage(
                              File(profileController.profileImagePath.value))
                          : null,
                  child: profileController.profileImagePath.value.isEmpty
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  profileController.updateUserName(nameController.text);
                  Get.back();
                } else {
                  Get.snackbar("Error", "Nama tidak boleh kosong!");
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
