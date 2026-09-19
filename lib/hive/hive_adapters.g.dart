// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class QuizHistoryModelAdapter extends TypeAdapter<QuizHistoryModel> {
  @override
  final typeId = 0;

  @override
  QuizHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizHistoryModel(
      id: fields[0] as String,
      categoryName: fields[1] as String,
      difficultyName: fields[2] as String,
      correctAnswers: (fields[3] as num).toInt(),
      totalQuestions: (fields[4] as num).toInt(),
      completedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizHistoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.difficultyName)
      ..writeByte(3)
      ..write(obj.correctAnswers)
      ..writeByte(4)
      ..write(obj.totalQuestions)
      ..writeByte(5)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
