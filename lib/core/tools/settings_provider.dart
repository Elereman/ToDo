import 'dart:async';

import 'package:ToDo/core/tools/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

class SettingsProvider {
  final BehaviorSubject<SettingsState> _stateStreamController;

  final SettingsRepository _settingsRepository;

  SettingsState _state;

  SettingsProvider(this._settingsRepository)
      : _stateStreamController = BehaviorSubject<SettingsState>();

  Future<void> requireAllSettings() async => _stateStreamController
        .add(SettingsState(await _settingsRepository.readAll()));

  Future<bool> resetAllSettings() => _settingsRepository.resetAll();

  Stream<SettingsState> get stateStream => _stateStreamController.stream;
}
