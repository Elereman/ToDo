import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/home_page_bloc.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/models/setting.dart';
import 'package:ToDo/models/settings_repository.dart';
import 'package:ToDo/models/shared_preferences_settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SettingsWidgetBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;
  final SettingsRepository _settingsRepository;
  final HomePageBloc _bloc;

  SettingsWidgetBloc(this._bloc)
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>(),
        _settingsRepository = SharedPreferencesSettingsRepository() {
    _settingsRepository.initialize();
    _eventStreamController.stream.listen((BlocEvent event) => _handleEvent(event));
  }

  Future<void> _handleEvent(BlocEvent event) async {
    switch (event.type) {
      case SettingsChangedPressedEvent:
        final SettingsChangedPressedEvent _event = event as SettingsChangedPressedEvent;
        _settingsRepository.update(_event.setting);
        print('SettingsChangedPressed');
        final SettingsChangedState<List<Setting<String>>> _state =
        SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll())
        ;
        _stateStreamController.add(_state);
        break;

      case SettingsResetPressedEvent:
      //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        await _settingsRepository.resetAll();
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll()));
        break;

      case SettingsBuildEvent:
      //final SettingsResetPressedEvent _event = event as SettingsResetPressedEvent;
        _stateStreamController.add(SettingsChangedState<List<Setting<String>>>
          (await _settingsRepository.readAll()));
        break;
    }
  }

  void _sendEventToBloc(BlocEvent event) {
    _bloc.eventSink.add(event);
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;

  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}

class SettingsResetPressedEvent extends BlocEvent {}

class SettingsBuildEvent extends BlocEvent {}

class SettingsChangedPressedEvent extends BlocEvent {
  final Setting<String> data;

  SettingsChangedPressedEvent({@required this.data});


  Setting<String> get setting => data;
}

class SettingsChangedState<T> extends BlocState<T> {
  final T data;

  SettingsChangedState(this.data);

  @override
  T get stateData => data;
}