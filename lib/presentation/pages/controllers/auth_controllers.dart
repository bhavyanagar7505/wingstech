import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taskify/core/routes/app_routes.dart';
import 'package:taskify/core/utils/validators.dart';
import 'package:taskify/core/utils/app_snackbar.dart';
import 'package:taskify/core/errors/firebase_auth_errors.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  RxString email = ''.obs;
  RxString password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  /// Handle auth state changes
  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.home);

      // Init FCM ONLY after login
      await _initFCM();
    }
  }

  // ============================
  // LOGIN
  // ============================
  Future<void> login() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);

    if (emailError != null) {
      AppSnackbar.error(emailError);
      return;
    }
    if (passError != null) {
      AppSnackbar.error(passError);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
    } on FirebaseAuthException catch (e) {
      AppSnackbar.error(FirebaseAuthErrors.message(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ============================
  // REGISTER
  // ============================
  Future<void> register() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);

    if (emailError != null) {
      AppSnackbar.error(emailError);
      return;
    }
    if (passError != null) {
      AppSnackbar.error(passError);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
    } on FirebaseAuthException catch (e) {
      AppSnackbar.error(FirebaseAuthErrors.message(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ============================
  // LOGOUT
  // ============================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================
  // FCM INITIALIZATION
  // ============================
  Future<void> _initFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission (Android 13+ / iOS)
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();
      if (token == null || firebaseUser.value == null) return;

      // Save token per user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .set(
        {
          'email': firebaseUser.value!.email,
          'fcmToken': token,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Foreground notification listener
      FirebaseMessaging.onMessage.listen((message) {
        Get.snackbar(
          message.notification?.title ?? 'Notification',
          message.notification?.body ?? '',
        );
      });
    } catch (e) {
      // NEVER crash app
      print('FCM init failed: $e');
    }
  }
}
