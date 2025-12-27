import 'package:get/get.dart';
import 'package:taskify/presentation/pages/controllers/auth_controllers.dart';
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
