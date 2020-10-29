import 'package:ToDo/domain/entities/setting.dart';

class SettingsState {
  final Map<String, Setting<String>> _settings;

  SettingsState(this._settings);

  Map<String, Setting<String>> get settings => _settings;
}
