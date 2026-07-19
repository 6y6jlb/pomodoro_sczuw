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
      telegramEnabled: fields[2] == null ? false : fields[2] as bool,
      telegramBotToken: fields[3] == null ? '' : fields[3] as String,
      telegramChatId: fields[4] == null ? '' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sessionDuration)
      ..writeByte(1)
      ..write(obj.breakDuration)
      ..writeByte(2)
      ..write(obj.telegramEnabled)
      ..writeByte(3)
      ..write(obj.telegramBotToken)
      ..writeByte(4)
      ..write(obj.telegramChatId);
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
