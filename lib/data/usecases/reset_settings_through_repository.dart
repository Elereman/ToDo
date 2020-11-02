import 'package:ToDo/core/tools/settings_provider/settings_provider.dart';
import 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/reset_settings.dart';

class ResetSettingsUseCaseThroughRepository implements ResetSettingsUseCase {
  final SettingsProvider _settingsProvider;

  ResetSettingsUseCaseThroughRepository(this._settingsProvider);

  @override
  Future<Map<String, Setting<String>>> call() async {
    await _settingsProvider.resetAllSettings();
    await _settingsProvider.resetAllSettings();
    final SettingsProviderState _settingsState =
        await _settingsProvider.stateStream.first;
    return _settingsState.settings;
  }
}
