
import 'package:flutter/material.dart';
import '../models/todo.dart';

class AddTodoBottomSheet extends StatefulWidget {
  final Function(List<Todo>) onAdd;
  const AddTodoBottomSheet({super.key, required this.onAdd});

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedTime;
  final List<Todo> _tasks = [];

  void _addTask() {
    final taskText = _taskController.text;

    if (taskText.isNotEmpty) {
      setState(() {
        _tasks.add(Todo(
          id: DateTime.now().toString(),
          title: taskText,
          description: "",
          time: _selectedTime,
        ));
        _taskController.clear();
        _selectedTime = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      });
    }
  }

  void _confirmTasks() {
    widget.onAdd(_tasks);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight - MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            hintText: "Enter Your Task",
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          maxLines: null,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _selectTime,
                          child: Text(
                            _selectedTime == null ? "Select Time" : "Selected Time: ${_selectedTime!.toLocal().hour}:${_selectedTime!.toLocal().minute.toString().padLeft(2, '0')}",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _addTask,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Add Task"),
                        ),
                        const SizedBox(height: 15),
                        if (_tasks.isNotEmpty) ...[
                          Text(
                            "Tasks to be added:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: _tasks.map((task) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(task.title),
                                leading: Icon(Icons.task),
                                subtitle: task.time != null ? Text("Time: ${task.time!.toLocal().hour}:${task.time!.toLocal().minute.toString().padLeft(2, '0')}") : null,
                              ),
                            )).toList(),
                          ),
                        ],
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _confirmTasks,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Confirm Tasks"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
