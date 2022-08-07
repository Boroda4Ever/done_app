import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'hive_task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final String importance;
  @HiveField(3)
  final DateTime deadline;
  @HiveField(4)
  final bool done;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.text,
    required this.importance,
    required this.deadline,
    required this.done,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        importance,
        deadline,
        done,
        createdAt,
        updatedAt,
      ];

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: int.parse(json['id']),
      text: json['text'] as String,
      importance: json['importance'] as String,
      deadline: DateTime.now(),
      done: json['done'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['changed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'text': text,
      'importance': importance,
      'deadline': deadline.toUtc().millisecondsSinceEpoch,
      'done': done.toString(),
      'created_at': createdAt.toUtc().millisecondsSinceEpoch,
      'updated_at': updatedAt.toUtc().millisecondsSinceEpoch,
    };
  }
}
