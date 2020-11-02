import 'package:ToDo/domain/usecases/get_settings_list.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/event.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';

class GetSettingsListEvent implements SettingsDrawerEvent<SettingsDrawerState> {
  final GetSettingsListUseCase _getSettingsListUseCase;

  GetSettingsListEvent(this._getSettingsListUseCase);

  @override
  Future<SettingsDrawerState> reduce(SettingsDrawerState oldState) async =>
      SettingsDrawerState(await _getSettingsListUseCase());
}
