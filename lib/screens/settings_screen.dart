import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/integrations/telegram_integration.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_preference.dart';
import 'package:pomodoro_sczuw/utils/consts/sound_preset.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _inputBorderRadius = BorderRadius.all(Radius.circular(12));
  static final _inputBorder = OutlineInputBorder(borderRadius: _inputBorderRadius);

  late final TextEditingController _telegramBotTokenController;
  late final TextEditingController _telegramChatIdController;
  bool _controllersInitialized = false;
  bool _isSendingTest = false;

  @override
  void initState() {
    super.initState();
    _telegramBotTokenController = TextEditingController();
    _telegramChatIdController = TextEditingController();
  }

  @override
  void dispose() {
    _telegramBotTokenController.dispose();
    _telegramChatIdController.dispose();
    super.dispose();
  }

  void _syncTelegramControllers(String token, String chatId) {
    if (_controllersInitialized) return;
    _telegramBotTokenController.text = token;
    _telegramChatIdController.text = chatId;
    _controllersInitialized = true;
  }

  bool _areTelegramFieldsFilled(String token, String chatId) {
    return token.trim().isNotEmpty && chatId.trim().isNotEmpty;
  }

  Future<void> _updateTelegramField({
    required Future<void> Function(String value) save,
    required String value,
  }) async {
    final notifier = ref.read(pomodoroSettingsProvider.notifier);
    await save(value);

    final settings = ref.read(pomodoroSettingsProvider).value;
    if (settings == null) return;

    if (settings.telegramEnabled &&
        !_areTelegramFieldsFilled(
          settings.telegramBotToken,
          settings.telegramChatId,
        )) {
      await notifier.updateTelegramEnabled(false);
    }
  }

  Future<void> _sendTelegramTest() async {
    final settings = ref.read(pomodoroSettingsProvider).value;
    if (settings == null) return;
    if (!_areTelegramFieldsFilled(
      settings.telegramBotToken,
      settings.telegramChatId,
    )) {
      return;
    }

    setState(() => _isSendingTest = true);

    final integration = TelegramIntegration(
      credentialsProvider: () => TelegramCredentials(
        enabled: true,
        botToken: settings.telegramBotToken,
        chatId: settings.telegramChatId,
      ),
    );

    final error = await integration.sendTestMessage();
    await integration.dispose();

    if (!mounted) return;
    setState(() => _isSendingTest = false);

    final messenger = ScaffoldMessenger.of(context);
    final l10n = L10n().t;
    if (error == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.telegram_testSent)),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.telegram_testError(error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(sessionProvider);
    final timerColors = Theme.of(context).extension<TimerColors>()!;
    final settingsAsync = ref.watch(pomodoroSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n().t.settingsScreenTitle, style: AppTextStyles.title),
        backgroundColor: timer.state.colorLevel(timerColors),
      ),
      body: settingsAsync.when(
        data: (settings) {
          _syncTelegramControllers(
            settings.telegramBotToken,
            settings.telegramChatId,
          );

          final telegramFieldsFilled = _areTelegramFieldsFilled(
            settings.telegramBotToken,
            settings.telegramChatId,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${L10n().t.sessionDurationLabel} ${settings.sessionDuration ~/ 60} ${L10n().t.unitShort_minute}',
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Slider(
                  value: settings.sessionDuration.toDouble(),
                  min: 0.toDouble(),
                  max: SessionState.activity.maxDuration.toDouble(),
                  divisions: 12,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSessionDuration(value.toInt());
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '${L10n().t.restDurationLabel} ${settings.breakDuration ~/ 60} ${L10n().t.unitShort_minute}',
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Slider(
                  value: settings.breakDuration.toDouble(),
                  min: 0.toDouble(),
                  max: SessionState.rest.maxDuration.toDouble(),
                  divisions: 12,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateBreakDuration(value.toInt());
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(pomodoroSettingsProvider.notifier)
                          .resetSessionDurationsToDefaults();
                    },
                    child: Text(L10n().t.action_resetToDefaults),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  L10n().t.theme_sectionTitle,
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _SettingsOptionChip(
                      label: L10n().t.theme_system,
                      selected: AppThemePreference.normalize(settings.themeMode) ==
                          AppThemePreference.system,
                      onTap: () {
                        ref
                            .read(pomodoroSettingsProvider.notifier)
                            .updateThemeMode(AppThemePreference.system);
                      },
                    ),
                    _SettingsOptionChip(
                      label: L10n().t.theme_light,
                      selected: settings.themeMode == AppThemePreference.light,
                      onTap: () {
                        ref
                            .read(pomodoroSettingsProvider.notifier)
                            .updateThemeMode(AppThemePreference.light);
                      },
                    ),
                    _SettingsOptionChip(
                      label: L10n().t.theme_dark,
                      selected: settings.themeMode == AppThemePreference.dark,
                      onTap: () {
                        ref
                            .read(pomodoroSettingsProvider.notifier)
                            .updateThemeMode(AppThemePreference.dark);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  L10n().t.restOverlay_sectionTitle,
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(L10n().t.restOverlay_enabled),
                  value: settings.restOverlayEnabled,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateRestOverlayEnabled(value);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  L10n().t.sounds_sectionTitle,
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                _SoundEventSetting(
                  label: L10n().t.sounds_userAction,
                  value: settings.soundUserAction,
                  defaultValue: SoundPreset.toggle,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSoundUserAction(value);
                  },
                ),
                _SoundEventSetting(
                  label: L10n().t.sounds_sessionComplete,
                  value: settings.soundSessionComplete,
                  defaultValue: SoundPreset.request,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSoundSessionComplete(value);
                  },
                ),
                _SoundEventSetting(
                  label: L10n().t.sounds_stateActivity,
                  value: settings.soundStateActivity,
                  defaultValue: SoundPreset.off,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSoundStateActivity(value);
                  },
                ),
                _SoundEventSetting(
                  label: L10n().t.sounds_stateRest,
                  value: settings.soundStateRest,
                  defaultValue: SoundPreset.off,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSoundStateRest(value);
                  },
                ),
                _SoundEventSetting(
                  label: L10n().t.sounds_stateInactivity,
                  value: settings.soundStateInactivity,
                  defaultValue: SoundPreset.off,
                  onChanged: (value) {
                    ref
                        .read(pomodoroSettingsProvider.notifier)
                        .updateSoundStateInactivity(value);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  L10n().t.telegram_sectionTitle,
                  style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(L10n().t.telegram_notificationsEnabled),
                  value: settings.telegramEnabled,
                  onChanged: (telegramFieldsFilled || settings.telegramEnabled)
                      ? (value) {
                          if (value && !telegramFieldsFilled) return;
                          ref
                              .read(pomodoroSettingsProvider.notifier)
                              .updateTelegramEnabled(value);
                        }
                      : null,
                ),
                TextField(
                  controller: _telegramBotTokenController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: L10n().t.telegram_botTokenLabel,
                    border: _inputBorder,
                    enabledBorder: _inputBorder,
                    focusedBorder: _inputBorder,
                  ),
                  onChanged: (value) {
                    _updateTelegramField(
                      save: ref
                          .read(pomodoroSettingsProvider.notifier)
                          .updateTelegramBotToken,
                      value: value,
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _telegramChatIdController,
                  decoration: InputDecoration(
                    labelText: L10n().t.telegram_chatIdLabel,
                    border: _inputBorder,
                    enabledBorder: _inputBorder,
                    focusedBorder: _inputBorder,
                  ),
                  onChanged: (value) {
                    _updateTelegramField(
                      save: ref
                          .read(pomodoroSettingsProvider.notifier)
                          .updateTelegramChatId,
                      value: value,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  L10n().t.telegram_setupHint,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: _inputBorderRadius,
                    ),
                  ),
                  onPressed: (!_isSendingTest && telegramFieldsFilled)
                      ? _sendTelegramTest
                      : null,
                  child: Text(
                    _isSendingTest
                        ? L10n().t.telegram_sendingTest
                        : L10n().t.telegram_sendTest,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _SoundEventSetting extends StatelessWidget {
  const _SoundEventSetting({
    required this.label,
    required this.value,
    required this.defaultValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String defaultValue;
  final ValueChanged<String> onChanged;

  bool get _isDefaultSelected => value == defaultValue;
  bool get _isOffSelected => SoundPreset.isOff(value) && !_isDefaultSelected;
  bool get _isCustomSelected => !_isDefaultSelected && !SoundPreset.isOff(value);

  Future<void> _chooseFile(BuildContext context) async {
    const typeGroup = XTypeGroup(
      label: 'audio',
      extensions: ['mp3', 'wav', 'ogg', 'm4a', 'aac'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    final path = file.path;
    if (!SoundPreset.isValidCustomPath(path)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n().t.sounds_customFileInvalid)),
      );
      return;
    }
    onChanged(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n().t;
    final customLabel = _isCustomSelected ? p.basename(value) : l10n.sounds_chooseFile;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SettingsOptionChip(
                label: l10n.sounds_resetDefault,
                selected: _isDefaultSelected,
                onTap: () => onChanged(defaultValue),
              ),
              _SettingsOptionChip(
                label: l10n.sounds_presetOff,
                selected: _isOffSelected,
                onTap: () => onChanged(SoundPreset.off),
              ),
              _SettingsOptionChip(
                label: customLabel,
                selected: _isCustomSelected,
                onTap: () => _chooseFile(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsOptionChip extends StatelessWidget {
  const _SettingsOptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      elevation: selected ? 2 : 0,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88, maxWidth: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? colorScheme.outline : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
