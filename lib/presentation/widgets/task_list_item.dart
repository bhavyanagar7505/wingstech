import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/core/colors/colors.dart';
import 'package:taskify/core/routes/app_routes.dart';
import '../pages/controllers/dashboard_controller.dart';

class TaskListItem extends StatelessWidget {
  final String taskId;
  final String title;
  final String status;
  final DateTime createdAt;

  const TaskListItem({
    super.key,
    required this.taskId,
    required this.title,
    required this.status,
    required this.createdAt,
  });

  Color _statusColor() {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // 🔹 OPEN TASK DETAIL
        Get.toNamed(
          AppRoutes.taskDetail,
          arguments: taskId,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // 🔹 STATUS DOT
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _statusColor(),
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 12),

            // 🔹 TASK INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 QUICK ACTIONS
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  dashboardController.deleteTask(taskId);
                } else {
                  dashboardController.updateStatus(taskId, value);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                PopupMenuItem(
                  value: 'in_progress',
                  child: Text('In Progress'),
                ),
                PopupMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
