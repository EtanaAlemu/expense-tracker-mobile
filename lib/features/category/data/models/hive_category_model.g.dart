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
      description: fields[2] as String?,
      icon: fields[3] as String?,
      color: fields[4] as int?,
      type: fields[5] as String,
      userId: fields[6] as String,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      isDefault: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCategoryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isDefault);
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
