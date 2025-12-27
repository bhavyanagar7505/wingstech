import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/core/colors/colors.dart';
import 'package:taskify/core/routes/app_routes.dart';
import 'package:taskify/presentation/pages/controllers/auth_controllers.dart';
import 'package:taskify/presentation/pages/controllers/dashboard_controller.dart';
import 'package:taskify/presentation/widgets/dashboard_card.dart';
import 'package:taskify/presentation/widgets/task_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: AppColors.background,

      // ➕ ADD TASK
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(AppRoutes.addTask),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Obx(() {
            final user = authController.firebaseUser.value;
            return Row(
              children: [
                if (user?.email != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      user!.email!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.notifications),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  onPressed: authController.logout,
                ),
              ],
            );
          }),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: RefreshIndicator(
          onRefresh: dashboardController.refreshTasks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 OVERVIEW
                const Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(
                      () => dashboardController.searchQuery.value.isEmpty
                          ? const SizedBox()
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                dashboardController.searchQuery.value = '';
                              },
                            ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (v) => dashboardController.searchQuery.value = v,
                ),
                 const SizedBox(height: 15),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DashboardCard(
                        title: "Total Tasks",
                        count: dashboardController.totalTasks.value,
                        color: Colors.blue,
                      ),
                      DashboardCard(
                        title: "Pending",
                        count: dashboardController.pendingTasks.value,
                        color: Colors.orange,
                      ),
                      DashboardCard(
                        title: "In Progress",
                        count: dashboardController.inProgressTasks.value,
                        color: Colors.purple,
                      ),
                      DashboardCard(
                        title: "Completed",
                        count: dashboardController.completedTasks.value,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: dashboardController.filter.value == 'all',
                        onSelected: (_) {
                          dashboardController.filter.value = 'all';
                          dashboardController.fetchTasks();
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Pending'),
                        selected: dashboardController.filter.value == 'pending',
                        onSelected: (_) {
                          dashboardController.filter.value = 'pending';
                          dashboardController.fetchTasks();
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Completed'),
                        selected:
                            dashboardController.filter.value == 'completed',
                        onSelected: (_) {
                          dashboardController.filter.value = 'completed';
                          dashboardController.fetchTasks();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Obx(() {
                  if (dashboardController.tasks.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "No tasks found.",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dashboardController.tasks.length,
                    itemBuilder: (context, index) {
                      final task = dashboardController.tasks[index];

                      return TaskListItem(
                        taskId: task.id,
                        title: task['title'],
                        status: task['status'],
                        createdAt: task['createdAt'].toDate(),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
