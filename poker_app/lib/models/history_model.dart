import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0)
class HistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String combo;

  @HiveField(3)
  final List<String> cards;

  HistoryModel({
    required this.id,
    required this.date,
    required this.combo,
    required this.cards,
  });
}