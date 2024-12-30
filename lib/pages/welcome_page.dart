import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';

class WelcomePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final PageController pageController = PageController();

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          // Slide 1
          buildSlide(
            title: "Selamat Datang di MyTherapy",
            description: "Aplikasi yang membantu mengelola kesehatanmu.",
            imagePath: "assets/images/welcome1.png",
            showNextButton: true,
            onNext: () => pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          // Slide 2
          buildSlide(
            title: "Fitur Terbaik untuk Anda",
            description: "Atur pengingat obat dan pantau kesehatanmu.",
            imagePath: "assets/images/welcome2.png",
            showNextButton: true,
            onNext: () => pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          // Slide 3
          buildSlide(
            title: "Isi Data Profilmu",
            description: "Mulai dengan mengisi nama dan foto profil.",
            imagePath: "assets/images/welcome3.png",
            showNameInput: true,
            showFinishButton: true,
            onFinish: () {
              if (nameController.text.isNotEmpty) {
                profileController.updateUserName(nameController.text);
                Get.offAllNamed('/home'); // Arahkan ke halaman utama
              } else {
                Get.snackbar("Error", "Nama tidak boleh kosong!");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSlide({
    required String title,
    required String description,
    required String imagePath,
    bool showNextButton = false,
    VoidCallback? onNext,
    bool showNameInput = false,
    bool showFinishButton = false,
    VoidCallback? onFinish,
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (showNameInput)
            Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      profileController.updateProfileImage();
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Unggah Foto Profil"),
                ),
              ],
            ),
          if (showNextButton)
            ElevatedButton(
              onPressed: onNext,
              child: const Text("Lanjut"),
            ),
          if (showFinishButton)
            ElevatedButton(
              onPressed: onFinish,
              child: const Text("Selesai"),
            ),
        ],
      ),
    );
  }
}
