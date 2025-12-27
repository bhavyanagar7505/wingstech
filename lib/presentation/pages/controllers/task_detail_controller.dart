import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskDetailController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String taskId;

  RxMap<String, dynamic> task = <String, dynamic>{}.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments;
    _listenToTask();
  }

  void _listenToTask() {
    _firestore.collection('tasks').doc(taskId).snapshots().listen((doc) {
      if (doc.exists) {
        task.value = doc.data()!;
        isLoading.value = false;
      }
    });
  }

  Future<void> updateStatus(String status) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTask() async {
    await _firestore.collection('tasks').doc(taskId).delete();
    Get.back();
  }
}
