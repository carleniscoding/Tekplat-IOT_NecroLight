// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorDataAdapter extends TypeAdapter<SensorData> {
  @override
  final int typeId = 0;

  @override
  SensorData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensorData(
      id: fields[0] as String,
      heartRate: fields[1] as int,
      accelerometerX: fields[2] as double,
      accelerometerY: fields[3] as double,
      accelerometerZ: fields[4] as double,
      symptomScore: fields[5] as double,
      timestamp: fields[6] as DateTime,
      status: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SensorData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.heartRate)
      ..writeByte(2)
      ..write(obj.accelerometerX)
      ..writeByte(3)
      ..write(obj.accelerometerY)
      ..writeByte(4)
      ..write(obj.accelerometerZ)
      ..writeByte(5)
      ..write(obj.symptomScore)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
