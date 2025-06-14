import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TodoTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TodoTile({
    required this.task,
    required this.onDone,
    required this.onEdit,
    required this.onDelete,
  });

  Color getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.blue;
      case 'low':
      default:
        return Colors.green;
    }
  }

  String getPriorityLabel() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return 'HIGH';
      case 'medium':
        return 'MEDIUM';
      case 'low':
      default:
        return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PRIORITY LABEL
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getPriorityColor().withOpacity(0.1),
              border: Border.all(color: getPriorityColor(), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              getPriorityLabel(),
              style: TextStyle(
                color: getPriorityColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ISI TASK
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BARIS: TITLE + DEADLINE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Deadline
                    Text(
                      "📅 ${task.dueDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Description
                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // TOMBOL AKSI
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!task.isDone)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.black, size: 20),
                    onPressed: onDone,
                    tooltip: "Done",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              const SizedBox(height: 6),
              if (!task.isDone)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                  onPressed: onEdit,
                  tooltip: "Edit",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (task.isDone)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.black, size: 20),
                onPressed: onDelete,
                tooltip: "Delete",
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
