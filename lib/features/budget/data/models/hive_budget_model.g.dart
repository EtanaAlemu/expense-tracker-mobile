// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_budget_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveBudgetModelAdapter extends TypeAdapter<HiveBudgetModel> {
  @override
  final int typeId = 2;

  @override
  HiveBudgetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveBudgetModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      categoryId: fields[2] as String,
      limit: fields[3] as double,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveBudgetModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.limit)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveBudgetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
