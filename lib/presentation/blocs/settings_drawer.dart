import 'file:///D:/ToDo/lib/domain/entities/setting.dart';
import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';
import 'package:ToDo/tools/settings_provider.dart';
import 'package:rxdart/rxdart.dart';

class SettingsDrawerBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;
  final SettingsProvider _settingsProvider;

  SettingsDrawerBloc(this._settingsProvider)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>(){
    _eventStreamController
        .listen((BlocEvent event) => _handleSettingsWidgetEvent(event));
    _settingsProvider.stateStream.listen(
            (BlocState<dynamic> state) => _handleSettingsProviderState(state));
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
        _settingsProvider.eventSink.add(event);
        break;

      case SettingsResetPressedEvent:
      //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
      //await _settingsRepository.resetAll();
      //_stateStreamController.add(SettingsChangedState<List<Setting<String>>>(
      // await _settingsRepository.readAll()));
        _settingsProvider.eventSink.add(event);
        break;

      case SettingsBuildEvent:
      //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        _settingsProvider.eventSink.add(SettingsBuildEvent());
        break;
    }
  }

  Future<void> _handleSettingsProviderState(BlocState<dynamic> state) async {
    if (state is SettingsChangedState<List<Setting<String>>>) {
      _stateStreamController.add(state);
    }
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;

  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}