import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/edit_setting.dart';
import 'package:ToDo/domain/usecases/get_setting.dart';
import 'package:ToDo/domain/usecases/get_settings_list.dart';
import 'package:ToDo/domain/usecases/reset_settings.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/edit_setting.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/event.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/get_setting.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/get_settings_list.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/reset_settings.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class SettingsDrawerBloc {
  final BehaviorSubject<SettingsDrawerState> _stateSubject;
  final BehaviorSubject<SettingsDrawerEvent<SettingsDrawerState>> _eventSubject;

  final ResetSettingsUseCase _resetSettingsListUseCase;
  final GetSettingsListUseCase _getSettingsListUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final EditSettingUseCase _editSettingUseCase;

  SettingsDrawerState _state;

  SettingsDrawerBloc(
      {@required ResetSettingsUseCase resetSettingsListUseCase,
      @required GetSettingsListUseCase getSettingsListUseCase,
      @required GetSettingUseCase getSettingUseCase,
      @required EditSettingUseCase editSettingUseCase})
      : _stateSubject = BehaviorSubject<SettingsDrawerState>(),
        _eventSubject =
            BehaviorSubject<SettingsDrawerEvent<SettingsDrawerState>>(),
        _resetSettingsListUseCase = resetSettingsListUseCase,
        _getSettingUseCase = getSettingUseCase,
        _getSettingsListUseCase = getSettingsListUseCase,
        _editSettingUseCase = editSettingUseCase,
        super() {
    _eventSubject
        .listen((SettingsDrawerEvent<SettingsDrawerState> event) async {
      _state = await event.reduce(_state);
      _stateSubject.sink.add(_state);
    });
  }

  Stream<SettingsDrawerState> get stateStream => _stateSubject.stream;

  void resetSettings() {
    _eventSubject.add(ResetSettingsEvent(_resetSettingsListUseCase));
  }

  void getSettingsList() {
    _eventSubject.add(GetSettingsListEvent(_getSettingsListUseCase));
  }

  void getSetting(String setting) {
    _eventSubject.add(GetSettingEvent(setting, _getSettingUseCase));
  }

  void editSetting(Setting<String> setting) {
    _eventSubject.add(EditSettingEvent(_editSettingUseCase, setting));
  }
}
