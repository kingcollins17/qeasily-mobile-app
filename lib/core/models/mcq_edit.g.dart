// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_edit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MCQuestionEditAdapter extends TypeAdapter<MCQuestionEdit> {
  @override
  final int typeId = 10;

  @override
  MCQuestionEdit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MCQuestionEdit(
      query: fields[1] as String,
      explanation: fields[2] as String,
      correct: fields[3] as String,
      difficulty: fields[4] as String,
    )
      ..topicId = fields[5] as int?
      ..userId = fields[6] as int?;
  }

  @override
  void write(BinaryWriter writer, MCQuestionEdit obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.explanation)
      ..writeByte(3)
      ..write(obj.correct)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.topicId)
      ..writeByte(6)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MCQuestionEditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
