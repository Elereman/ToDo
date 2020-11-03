import 'dart:async';

import 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

export 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';

class SettingsProvider {
  final BehaviorSubject<SettingsProviderState> _stateSubject;

  final SettingsRepository _settingsRepository;

  SettingsProviderState _state;

  SettingsProvider(this._settingsRepository)
      : _stateSubject = BehaviorSubject<SettingsProviderState>(),
        super();

  Future<void> requireAllSettings() async {
    _state = SettingsProviderState(await _settingsRepository.readAll());
    _stateSubject.add(_state);
  }

  Future<bool> resetAllSettings() async {
    final bool result = await _settingsRepository.resetAll();
    _state = SettingsProviderState(await _settingsRepository.readAll());
    return result;
  }

  Future<Setting<String>> editSetting(Setting<String> setting) async {
    final Setting<String> _newSetting = await _settingsRepository.update(setting);
    _state = SettingsProviderState(await _settingsRepository.readAll());
    _stateSubject.add(_state);
    return _newSetting;
  }

  Stream<SettingsProviderState> get stateStream => _stateSubject.stream;
}
