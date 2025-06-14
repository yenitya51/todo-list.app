import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import 'add_edit_todo_screen.dart';
import 'login_screen.dart';
import '../widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  final ApiService api;
  TodoListScreen({required this.api});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedTasks = await widget.api.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
        filteredTasks = fetchedTasks;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'failed to load data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notDoneTasks = filteredTasks.where((t) => !t.isDone).toList();
    final doneTasks = filteredTasks.where((t) => t.isDone).toList();
    final orderedTasks = [...notDoneTasks, ...doneTasks];

    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Task',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditTodoScreen(api: widget.api),
                  ),
                );
                await fetchData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              try {
                await widget.api.logoutFromServer();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : orderedTasks.isEmpty
                        ? const Center(child: Text("no tasks available"))
                        : ListView.builder(
                            itemCount: orderedTasks.length,
                            itemBuilder: (context, index) {
                              final task = orderedTasks[index];
                              return TodoTile(
                                task: task,
                                onDone: () async {
                                  final updatedTask = Task(
                                    id: task.id,
                                    title: task.title,
                                    description: task.description,
                                    priority: task.priority,
                                    dueDate: task.dueDate,
                                    isDone: true,
                                  );
                                  await widget.api.updateTask(updatedTask);
                                  await fetchData();
                                },
                                onDelete: () async {
                                  await widget.api.deleteTask(task.id);
                                  await fetchData();
                                },
                                onEdit: () async {
                                  if (task.isDone) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditTodoScreen(
                                        api: widget.api,
                                        task: task,
                                      ),
                                    ),
                                  );
                                  await fetchData();
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
