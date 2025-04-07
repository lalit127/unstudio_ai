import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unstudio_ai/models/user_model.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/services/firebase_service.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';

class AuthController extends GetxController {
  final FirebaseService _authService = FirebaseService();

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  RxBool isSignedIn = false.obs;
  RxBool isLoading = false.obs;
  RxnString uid = RxnString();
  Rx<UserModel> userModel = UserModel().obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  void checkSign() {
    isSignedIn.value = AppPreference.getStringFromSF('access_token') != null;
  }

  Future<void> setSignIn(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppPreference.addStringToSF('access_token', accessToken);
    isSignedIn.value = true;
  }

  Future<void> signUpWithEmail() async {
    isLoading.value = true;
    try {
      final credential = await _authService.signUp(
        emailController.text,
        passController.text,
      );
      uid.value = credential.user?.uid ?? '';

      // final profilePicUrl = await _authService.uploadProfilePic(
      //   uid.value!,
      //   profilePic,
      // );

      final newUser = UserModel(
        name: nameController.text,
        email: emailController.text,
        uid: uid.value ?? '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        profilePic: '',
        phoneNumber: '',
        bio: '',
      );

      await _authService.saveUserToFirestore(newUser);
      userModel.value = newUser;
      await _authService.saveUserToLocal(newUser);
      await setSignIn(userModel.value.uid ?? "");

      Get.offAllNamed(AppPages.home);
    } catch (e) {
      Get.snackbar("Error", "Signup failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail() async {
    isLoading.value = true;
    try {
      final credential = await _authService.signIn(
        emailController.text,
        passController.text,
      );
      uid.value = credential.user?.uid;

      final exists = await _authService.checkUserExists(uid.value!);

      if (exists) {
        final user = await _authService.getUserData(uid.value!);
        userModel.value = user;
      } else {
        // User does not exist in Firestore – create new user entry
        final newUser = UserModel(
          name:
              nameController.text.isNotEmpty ? nameController.text : 'New User',
          email: emailController.text,
          uid: uid.value!,
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          profilePic: '',
          phoneNumber: '',
          bio: '',
        );

        await _authService.saveUserToFirestore(newUser);
        userModel.value = newUser;
      }

      await _authService.saveUserToLocal(userModel.value);
      await setSignIn(userModel.value.uid ?? "");
      Get.offAllNamed(AppPages.home);
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserFromLocal() async {
    final user = await _authService.getUserFromLocal();
    if (user != null) {
      userModel.value = user;
      uid.value = user.uid;
    }
  }

  Future<void> userSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _authService.signOut();
    prefs.clear();
    isSignedIn.value = false;
    Get.offAllNamed(AppPages.login);
  }

  @override
  void onInit() {
    super.onInit();
    checkSign();
  }
}
