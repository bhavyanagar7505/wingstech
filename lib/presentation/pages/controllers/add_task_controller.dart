import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Form fields
  RxString title = ''.obs;
  RxString description = ''.obs;
  RxString status = 'pending'.obs;
  RxString priority = 'low'.obs;
  Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  RxBool isLoading = false.obs;

  Future<void> saveTask() async {
    if (title.value.trim().isEmpty) {
      Get.snackbar('Error', 'Task title is required');
      return;
    }

    try {
      isLoading.value = true;

      final uid = _auth.currentUser!.uid;

      await _firestore.collection('tasks').add({
        'title': title.value.trim(),
        'description': description.value.trim(),
        'status': status.value,
        'priority': priority.value,
        'assignedTo': uid,
        'createdBy': uid,
        'dueDate': dueDate.value,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.back(); 
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task');
    } finally {
      isLoading.value = false;
    }
  }
}
