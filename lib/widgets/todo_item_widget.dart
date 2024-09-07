import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/app_styles.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompleted;
  final Function(Todo) onUpdate;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onToggleCompleted,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blueGrey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          todo.title,
          style: todo.isCompleted
              ? AppStyles.completedTodoTextStyle
              : AppStyles.todoTextStyle,
        ),
        subtitle: Text(todo.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onToggleCompleted,
              icon: Icon(todo.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              color: AppStyles.primaryColor,
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppStyles.secondaryColor,
              ),
              onPressed: () {
                _showEditTodoDialog(context, todo);
              },
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    TextEditingController titleController =
    TextEditingController(text: todo.title);
    TextEditingController descriptionController =
    TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Todo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              controller: descriptionController,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Todo updatedTodo = Todo(
                id: todo.id,
                title: titleController.text,
                description: descriptionController.text,
                isCompleted: todo.isCompleted,
                time: todo.time, // Preserve the time
              );
              onUpdate(updatedTodo);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
