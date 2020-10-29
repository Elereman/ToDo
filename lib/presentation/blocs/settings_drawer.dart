import 'package:ToDo/core/tools/settings_provider.dart';
import 'package:ToDo/core/tools/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';

import 'package:rxdart/rxdart.dart';

class SettingsDrawerBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<SettingsState> _stateStreamController;
  final SettingsProvider _settingsProvider;

  SettingsDrawerBloc(this._settingsProvider)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<SettingsState>() {
    _eventStreamController
        .listen((BlocEvent event) => _handleSettingsWidgetEvent(event));
    _settingsProvider.stateStream.listen(
        (SettingsState state) => _handleSettingsProviderState(state));
  }

  Future<void> _handleSettingsWidgetEvent(BlocEvent event) async {
    switch (event.type) {
      case SettingsChangedPressedEvent:
        //    final SettingsChangedPressedEvent _event =
        //       event as SettingsChangedPressedEvent;
        //   _settingsRepository.update(_event.setting);
        //   print('SettingsChangedPressed');
        // final SettingsChangedState<List<Setting<String>>> _state =
        //    SettingsChangedState<List<Setting<String>>>(
        //       await _settingsRepository.readAll());
        // _stateStreamController.add(_state);
        //_settingsProvider.eventSink.add(event);
        break;

      case SettingsResetPressedEvent:
        //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        //await _settingsRepository.resetAll();
        //_stateStreamController.add(SettingsChangedState<List<Setting<String>>>(
        // await _settingsRepository.readAll()));
      _settingsProvider.resetAllSettings();
        //_settingsProvider.eventSink.add(event);
        break;

      case SettingsBuildEvent:
        //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
      _settingsProvider.requireAllSettings();
        //_settingsProvider.eventSink.add(SettingsBuildEvent());
        break;
    }
  }

  Future<void> _handleSettingsProviderState(SettingsState state) async {
      _stateStreamController.add(state);
  }

  Stream<SettingsState> get stateStream => _stateStreamController.stream;

  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}
