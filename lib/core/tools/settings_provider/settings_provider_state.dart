import 'package:ToDo/domain/entities/setting.dart';

class SettingsProviderState {
  final Map<String, Setting<String>> _settings;

  SettingsProviderState(this._settings);

  Map<String, Setting<String>> get settings => _settings;
}
