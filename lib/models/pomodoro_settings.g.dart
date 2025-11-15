// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroSettingsAdapter extends TypeAdapter<PomodoroSettings> {
  @override
  final int typeId = 0;

  @override
  PomodoroSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSettings(
      sessionDuration: fields[0] as int,
      breakDuration: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sessionDuration)
      ..writeByte(1)
      ..write(obj.breakDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
