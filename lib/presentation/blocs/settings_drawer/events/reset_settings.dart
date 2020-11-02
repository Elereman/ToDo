import 'package:ToDo/domain/usecases/reset_settings.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/events/event.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';

class ResetSettingsEvent implements SettingsDrawerEvent<SettingsDrawerState> {
  final ResetSettingsUseCase _resetSettingsListUseCase;

  ResetSettingsEvent(this._resetSettingsListUseCase);

  @override
  Future<SettingsDrawerState> reduce(SettingsDrawerState oldState) async =>
      SettingsDrawerState(await _resetSettingsListUseCase());
}
