import 'package:ToDo/domain/entities/setting.dart';

class SettingsDrawerState {
  final Map<String, Setting<String>> _settings;

  SettingsDrawerState(this._settings);

  Map<String, Setting<String>> get settings => _settings;
}
