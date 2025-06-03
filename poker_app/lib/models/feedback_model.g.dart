// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppFeedbackAdapter extends TypeAdapter<AppFeedback> {
  @override
  final int typeId = 1;

  @override
  AppFeedback read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppFeedback(
      id: fields[0] as String,
      username: fields[1] as String,
      rating: fields[2] as int,
      comment: fields[3] as String,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppFeedback obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFeedbackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
