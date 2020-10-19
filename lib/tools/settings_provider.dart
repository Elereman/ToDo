import 'dart:async';

import 'file:///D:/ToDo/lib/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';
import 'package:rxdart/rxdart.dart';

class SettingsProvider {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;

  final SettingsRepository _settingsRepository;

  SettingsProvider(this._settingsRepository)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>() {
    _settingsRepository.initialize();
    _eventStreamController
        .listen((BlocEvent value) async => await _handleEvent(value));
  }

  Future<void> _handleEvent(BlocEvent event) async {
    switch (event.type) {
      case SettingsChangedPressedEvent:
        final SettingsChangedPressedEvent _event =
            event as SettingsChangedPressedEvent;
        _settingsRepository.update(_event.setting);
        print('SettingsChangedPressed');
        final SettingsChangedState<List<Setting<String>>> _state =
            SettingsChangedState<List<Setting<String>>>(
                await _settingsRepository.readAll());
        _stateStreamController.add(_state);
        break;

      case SettingsResetPressedEvent:
        //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        await _settingsRepository.resetAll();
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>(
            await _settingsRepository.readAll()));
        break;

      case SettingsBuildEvent:
        //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>(
            await _settingsRepository.readAll()));
        break;
    }
  }

  StreamSink<BlocEvent> get eventSink => _eventStreamController.sink;

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;
}
