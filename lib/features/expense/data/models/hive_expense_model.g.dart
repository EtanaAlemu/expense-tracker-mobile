// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveExpenseModelAdapter extends TypeAdapter<HiveExpenseModel> {
  @override
  final int typeId = 4;

  @override
  HiveExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveExpenseModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      description: fields[4] as String,
      date: fields[5] as DateTime,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveExpenseModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
