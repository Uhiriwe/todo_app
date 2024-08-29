import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/todo_model.dart';

class DatabaseServices {
  final CollectionReference todoCollection = FirebaseFirestore.instance.collection("todos");
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  User? user = FirebaseAuth.instance.currentUser;

  // Add a new task
  Future<DocumentReference> addTodoItem(String title, String description) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update a task
  Future<void> updateTodo(String id, String title, String description) async {
    return await todoCollection.doc(id).update({
      'title': title,
      'description': description,
    });
  }

  // Update the completion status of a task
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  // Delete a task
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  // Get a stream of pending tasks
  Stream<List<Todo>> get todos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Get a stream of completed tasks
  Stream<List<Todo>> get completedTodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        timestamp: doc['createdAt'] ?? '',
      );
    }).toList();
  }

  // Check if the current user is a staff member
  Future<bool> isStaffMember(String uid) async {
    DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return (userDoc.data() as Map<String, dynamic>)['isStaffMember'] ?? false;
    }
    return false;
  }
}
