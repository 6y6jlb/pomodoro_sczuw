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
      restOverlayEnabled: fields[5] == null ? false : fields[5] as bool,
      soundUserAction: fields[6] == null ? 'toggle' : fields[6] as String,
      soundSessionComplete: fields[7] == null ? 'request' : fields[7] as String,
      soundStateActivity: fields[8] == null ? '' : fields[8] as String,
      soundStateRest: fields[9] == null ? '' : fields[9] as String,
      soundStateInactivity: fields[10] == null ? '' : fields[10] as String,
      themeMode: fields[11] == null ? 'system' : fields[11] as String,
      themePalette: fields[12] == null ? 'default' : fields[12] as String,
      locale: fields[13] == null ? 'system' : fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.sessionDuration)
      ..writeByte(1)
      ..write(obj.breakDuration)
      ..writeByte(2)
      ..write(obj.telegramEnabled)
      ..writeByte(3)
      ..write(obj.telegramBotToken)
      ..writeByte(4)
      ..write(obj.telegramChatId)
      ..writeByte(5)
      ..write(obj.restOverlayEnabled)
      ..writeByte(6)
      ..write(obj.soundUserAction)
      ..writeByte(7)
      ..write(obj.soundSessionComplete)
      ..writeByte(8)
      ..write(obj.soundStateActivity)
      ..writeByte(9)
      ..write(obj.soundStateRest)
      ..writeByte(10)
      ..write(obj.soundStateInactivity)
      ..writeByte(11)
      ..write(obj.resolvedThemeMode)
      ..writeByte(12)
      ..write(obj.resolvedThemePalette)
      ..writeByte(13)
      ..write(obj.resolvedLocale);
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
