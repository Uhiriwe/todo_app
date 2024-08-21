import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Services/database_services.dart';
import 'package:todo_app/model/todo_model.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({Key? key}) : super(key: key);

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  User? user;
  late String uid;

  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: _databaseServices.todos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Todo> todos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              final DateTime dt = todo.timestamp.toDate(); // Ensure the field name is correct
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        label: "Mark",
                        onPressed: (context) {
                          _databaseServices.updateTodoStatus(todo.id, true);
                        },
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                        onPressed: (context) {
                          _showTaskDialog(context, todo: todo);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                        onPressed: (context) async {
                          await _databaseServices.deleteTodoTask(todo.id);
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(todo.description),
                    trailing: Text(
                      '${dt.day}/${dt.month}/${dt.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No tasks available',style: TextStyle(color: Colors.white),));
        }
      },
    );
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}) {
    final TextEditingController _titleController =
    TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
    TextEditingController(text: todo?.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            todo == null ? "Add Task" : "Edit Task",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (todo == null) {
                  await _databaseServices.addTodoItem(
                    _titleController.text,
                    _descriptionController.text,
                  );
                } else {
                  await _databaseServices.updateTodo(
                    todo.id!,
                    _titleController.text,
                    _descriptionController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(todo == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
