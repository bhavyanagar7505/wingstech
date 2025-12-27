import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:taskify/core/colors/colors.dart';
import '../controllers/task_detail_controller.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: controller.deleteTask,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final task = controller.task;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['title'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text("Status: ${task['status']}"),

              const SizedBox(height: 20),

              DropdownButton<String>(
                value: task['status'],
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(
                    value: 'in_progress',
                    child: Text('In Progress'),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.updateStatus(value);
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
