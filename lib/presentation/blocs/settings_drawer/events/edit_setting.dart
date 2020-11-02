import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/edit_setting.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/event.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';

class EditSettingEvent implements SettingsDrawerEvent<SettingsDrawerState> {
  final EditSettingUseCase _editSettingUseCase;
  final Setting<String> _setting;

  EditSettingEvent(this._editSettingUseCase, this._setting);

  @override
  Future<SettingsDrawerState> reduce(SettingsDrawerState oldState) async {
    final Setting<String> newSetting = await _editSettingUseCase(_setting);
    oldState.settings[_setting.key] = newSetting;
    return oldState;
  }
}
