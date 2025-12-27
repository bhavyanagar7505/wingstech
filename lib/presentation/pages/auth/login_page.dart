import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/core/colors/colors.dart';
import '../../widgets/auth_text_field.dart';
import '../controllers/auth_controllers.dart';
import '../../../core/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.register);
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
                const Text(
                  "Login Here",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),
                AuthTextField(
                  hint: "Email",
                  icon: Icons.email_outlined,
                  onChanged: (v) => controller.email.value = v,
                ),

                const SizedBox(height: 20),
                AuthTextField(
                  hint: "Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                  onChanged: (v) => controller.password.value = v,
                ),

                const SizedBox(height: 40),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                await controller.login();
                                if (controller.firebaseUser.value != null) {
                                  Get.offAllNamed(AppRoutes.home);
                                }
                              },
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),

                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.register);
                    },
                    child: const Text(
                      "Don’t have an account? Register",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
