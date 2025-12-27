import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/core/colors/colors.dart';
import '../controllers/add_task_controller.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTaskController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Add Task',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => controller.title.value = v,
              ),

              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Optional task description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => controller.description.value = v,
              ),

              const SizedBox(height: 24),
              const Text(
                'Priority',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() => DropdownButtonFormField<String>(
                    value: controller.priority.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'low',
                        child: Text('Low'),
                      ),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Text('Medium'),
                      ),
                      DropdownMenuItem(
                        value: 'high',
                        child: Text('High'),
                      ),
                    ],
                    onChanged: (v) => controller.priority.value = v!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),

              const SizedBox(height: 24),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() => DropdownButtonFormField<String>(
                    value: controller.status.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'in_progress',
                        child: Text('In Progress'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                    ],
                    onChanged: (v) => controller.status.value = v!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),

              const SizedBox(height: 24),

              const Text(
                'Due Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() => ListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    title: Text(
                      controller.dueDate.value == null
                          ? 'Pick due date'
                          : '${controller.dueDate.value!.day}/${controller.dueDate.value!.month}/${controller.dueDate.value!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      controller.dueDate.value = date;
                    },
                  )),

              const SizedBox(height: 40),

              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveTask,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Task',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
