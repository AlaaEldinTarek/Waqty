
class TaskModel {
  final String id;
  final String title;
  final String details;
  final DateTime dateTime;
  final String group;
  final bool isCompleted;
  final String repeat; // default: 'none'

  TaskModel({
    required this.id,
    required this.title,
    required this.details,
    required this.dateTime,
    required this.group,
    this.isCompleted = false,
    this.repeat = 'none', // 'none' means لا تكرار // none / daily / everyOtherDay / weekly / monthly
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'dateTime': dateTime.toIso8601String(),
      'group': group,
      'isCompleted': isCompleted,
      'repeat': repeat,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      dateTime: DateTime.parse(map['dateTime']),
      group: map['group'],
      isCompleted: map['isCompleted'] ?? false,
      repeat: map['repeat'] ?? 'none',
    );
  }
}
