import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';
import '../utils/app_styles.dart';
import '../widgets/todo_item_widget.dart';
import '../widgets/add_todo_bottom_sheet.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoController _todoController = TodoController();

  void _handleAddTasks(List<Todo> tasks) {
    setState(() {
      for (var task in tasks) {
        _todoController.addTodo(task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

    // Group tasks by time
    final groupedTasks = <DateTime, List<Todo>>{};
    for (var todo in _todoController.todos) {
      final time = todo.time ?? DateTime(0);
      if (!groupedTasks.containsKey(time)) {
        groupedTasks[time] = [];
      }
      groupedTasks[time]!.add(todo);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo List",
          style: AppStyles.appBarTitleStyle,
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: groupedTasks.entries.map((entry) {
                  final time = entry.key;
                  final tasks = entry.value;
                  final formattedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (time != DateTime(0))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Time: $formattedTime",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Column(
                        children: tasks.map((todo) => TodoItemWidget(
                          todo: todo,
                          onDelete: () {
                            _todoController.deleteTodo(todo);
                            setState(() {});
                          },
                          onToggleCompleted: () {
                            _todoController.toggleComplete(todo);
                            setState(() {});
                          },
                          onUpdate: (updatedTodo) {
                            _todoController.updateTodo(updatedTodo);
                            setState(() {});
                          },
                        )).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTodoBottomSheet(
              onAdd: _handleAddTasks,
            ),
          );
        },
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        elevation: 8,
      ),
    );
  }
}
