import 'package:ToDo/core/tools/settings_provider/settings_provider.dart';
import 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/get_setting.dart';

class GetSettingUseCaseThroughRepository implements GetSettingUseCase {
  final SettingsProvider _settingsProvider;

  GetSettingUseCaseThroughRepository(this._settingsProvider);

  @override
  Future<Setting<String>> call(String setting) async {
    await _settingsProvider.requireAllSettings();
    final SettingsProviderState _settingsState =
        await _settingsProvider.stateStream.first;
    return _settingsState.settings[setting];
  }
}
