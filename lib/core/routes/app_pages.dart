import 'package:get/get.dart';
import 'package:taskify/presentation/pages/bindings/add_task_binding.dart';
import 'package:taskify/presentation/pages/bindings/dashboard_binding.dart';
import 'package:taskify/presentation/pages/notifications/notifications.dart';
import 'package:taskify/presentation/pages/task/add_task_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/bindings/auth_bindings.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      bindings: [AuthBinding(), DashboardBinding()],
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => const AddTaskPage(),
      binding: AddTaskBinding(),
    ),
    GetPage(name: AppRoutes.notifications, page: () => const Notifications()),
  ];
}
