import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HANSIKA TO-DO LIST ',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> tasks = ["Buy groceries", "Finish project", "Call mom"];
  TextEditingController taskController = TextEditingController();
  int? editIndex; // Variable to keep track of the task being edited

  void _addOrEditTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        if (editIndex == null) {
          // If no task is being edited, add a new one
          tasks.add(task);
        } else {
          // Update the task being edited
          tasks[editIndex!] = task;
          editIndex = null; // Reset after editing
        }
      });
      taskController.clear();
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showAddOrEditTaskDialog({String? task, int? index}) {
    if (task != null) {
      // If editing, prepopulate the text field with the task
      taskController.text = task;
      editIndex = index;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text(
            task == null ? "Add New Task" : "Edit Task",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              icon: Icon(Icons.task, color: Colors.amber),
              hintText: "Task Description",
              fillColor: Colors.white70,
              filled: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                taskController.clear();
                editIndex = null; // Reset if cancel is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(task == null ? "Add" : "Edit", style: TextStyle(color: Colors.white)),
              onPressed: () {
                _addOrEditTask(taskController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pink, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text("To-Do List", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(tasks[index], style: TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showAddOrEditTaskDialog(task: tasks[index], index: index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrEditTaskDialog();
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
