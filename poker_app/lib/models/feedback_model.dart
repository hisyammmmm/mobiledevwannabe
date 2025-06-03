import 'package:hive/hive.dart';

part 'feedback_model.g.dart';

@HiveType(typeId: 1)
class AppFeedback {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final int rating;

  @HiveField(3)
  final String comment;

  @HiveField(4)
  final DateTime createdAt;

  AppFeedback({
    required this.id,
    required this.username,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}