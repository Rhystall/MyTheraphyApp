import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userName = 'User'.obs;
  var profileImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  // Memuat data profil dari SharedPreferences
  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('userName') ?? 'User';
    profileImagePath.value = prefs.getString('profileImagePath') ?? '';
  }

  // Memperbarui nama pengguna
  Future<void> updateUserName(String newName) async {
    userName.value = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
  }

  // Memperbarui gambar profil
  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    } else {
      Get.snackbar("Error", "No image selected",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
