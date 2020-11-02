import 'package:ToDo/domain/usecases/get_setting.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/event.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';

class GetSettingEvent implements SettingsDrawerEvent<SettingsDrawerState> {
  final String _setting;
  final GetSettingUseCase _getSettingUseCase;

  GetSettingEvent(this._setting, this._getSettingUseCase);

  @override
  Future<SettingsDrawerState> reduce(SettingsDrawerState oldState) async {
    oldState.settings[_setting] = await _getSettingUseCase(_setting);
    return oldState;
  }
}
