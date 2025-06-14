class Task {
  final int id;
  final String title;
  final String description;
  final String priority;
  final DateTime dueDate;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.isDone,
  });

 factory Task.fromJson(Map<String, dynamic> json) {
  return Task(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    priority: json['priority'],
    dueDate: DateTime.parse(json['due_date']),
    isDone: json['is_done'] == 1 || json['is_done'] == true,
  );
}


  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'priority': priority,
        'due_date': dueDate.toIso8601String(),
        'is_done': isDone,
      };
}
