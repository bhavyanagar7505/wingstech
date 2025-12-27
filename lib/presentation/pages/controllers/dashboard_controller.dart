import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum TaskSort { createdAt, dueDate, priority }

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<TaskSort> sortBy = TaskSort.createdAt.obs;
  RxString filter = 'all'.obs;
  RxString searchQuery = ''.obs;

  Worker? _searchWorker;
  RxInt totalTasks = 0.obs;
  RxInt pendingTasks = 0.obs;
  RxInt inProgressTasks = 0.obs;
  RxInt completedTasks = 0.obs;

  RxList<QueryDocumentSnapshot<Map<String, dynamic>>> tasks =
      <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    _searchWorker = debounce(
      searchQuery,
      (_) => fetchTasks(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    super.onClose();
  }

  void fetchTasks() {
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
      docs.sort((a, b) {
        switch (sortBy.value) {
          case TaskSort.dueDate:
            return (a.data()['dueDate'] ?? Timestamp.now())
                .compareTo(b.data()['dueDate'] ?? Timestamp.now());

          case TaskSort.priority:
            return (a.data()['priority'] ?? '')
                .compareTo(b.data()['priority'] ?? '');

          case TaskSort.createdAt:
          default:
            return (b.data()['createdAt'] ?? Timestamp.now())
                .compareTo(a.data()['createdAt'] ?? Timestamp.now());
        }
      });
      if (filter.value != 'all') {
        docs =
            docs.where((d) => d.data()['status'] == filter.value).toList();
      }
      if (searchQuery.value.isNotEmpty) {
        docs = docs
            .where((d) => d
                .data()['title']
                .toString()
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
            .toList();
      }

      tasks.assignAll(docs);

      totalTasks.value = snapshot.docs.length;
      pendingTasks.value =
          snapshot.docs.where((d) => d['status'] == 'pending').length;
      inProgressTasks.value =
          snapshot.docs.where((d) => d['status'] == 'in_progress').length;
      completedTasks.value =
          snapshot.docs.where((d) => d['status'] == 'completed').length;
    });
  }

  void changeSort(TaskSort value) {
    sortBy.value = value;
    fetchTasks();
  }

  void changeFilter(String value) {
    filter.value = value;
    fetchTasks();
  }

  Future<void> refreshTasks() async {
    fetchTasks();
  }

  Future<void> updateStatus(String taskId, String status) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
