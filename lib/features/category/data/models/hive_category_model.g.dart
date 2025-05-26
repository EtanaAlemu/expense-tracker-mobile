// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCategoryModelAdapter extends TypeAdapter<HiveCategoryModel> {
  @override
  final int typeId = 1;

  @override
  HiveCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCategoryModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      type: fields[2] as String,
      color: fields[3] as dynamic,
      icon: fields[4] as String?,
      budget: fields[5] as double?,
      description: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      userId: fields[9] as String,
      isDefault: fields[10] as bool,
      transactionType: fields[11] as String,
      frequency: fields[12] as String?,
      defaultAmount: fields[13] as double?,
      isActive: fields[14] as bool?,
      isRecurring: fields[15] as bool?,
      lastProcessedDate: fields[16] as DateTime?,
      nextProcessedDate: fields[17] as DateTime?,
      isSynced: fields[18] as bool,
      isUpdated: fields[19] as bool,
      isDeleted: fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCategoryModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.budget)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.isDefault)
      ..writeByte(11)
      ..write(obj.transactionType)
      ..writeByte(12)
      ..write(obj.frequency)
      ..writeByte(13)
      ..write(obj.defaultAmount)
      ..writeByte(14)
      ..write(obj.isActive)
      ..writeByte(15)
      ..write(obj.isRecurring)
      ..writeByte(16)
      ..write(obj.lastProcessedDate)
      ..writeByte(17)
      ..write(obj.nextProcessedDate)
      ..writeByte(18)
      ..write(obj.isSynced)
      ..writeByte(19)
      ..write(obj.isUpdated)
      ..writeByte(20)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
