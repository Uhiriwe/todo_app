import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Services/database_services.dart';
import 'package:todo_app/model/todo_model.dart';

class CompletedWidget extends StatefulWidget {
  const CompletedWidget({Key? key}) : super(key: key);

  @override
  State<CompletedWidget> createState() => _CompletedWidgetState();
}

class _CompletedWidgetState extends State<CompletedWidget> {
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
      stream: _databaseServices.completedTodos,
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
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
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
                      style: TextStyle(fontWeight: FontWeight.w500,
                        decoration:TextDecoration.lineThrough,),
                    ),
                    subtitle: Text(todo.description,
                      style: TextStyle(decoration:TextDecoration.lineThrough,),
                    ),
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
          return Center(child: Text('No tasks available'));
        }
      },
    );
  }
}
