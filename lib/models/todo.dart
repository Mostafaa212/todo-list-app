// lib/models/todo.dart
class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? time; // New field for time

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.time,
  });
}
