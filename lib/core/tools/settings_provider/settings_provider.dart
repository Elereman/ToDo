import 'dart:async';

import 'package:ToDo/core/tools/settings_provider/events/event.dart';
import 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

export 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';

class SettingsProvider {
  final BehaviorSubject<SettingsProviderState> _stateSubject;
  final BehaviorSubject<SettingsProviderEvent<SettingsProviderState>>
      _eventSubject;

  final SettingsRepository _settingsRepository;

  SettingsProviderState _state;

  SettingsProvider(this._settingsRepository)
      : _stateSubject = BehaviorSubject<SettingsProviderState>(),
        _eventSubject =
            BehaviorSubject<SettingsProviderEvent<SettingsProviderState>>(),
        super() {
    _eventSubject
        .listen((SettingsProviderEvent<SettingsProviderState> event) async {
      _state = await event.reduce(_state);
      _stateSubject.add(_state);
    });
  }

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
