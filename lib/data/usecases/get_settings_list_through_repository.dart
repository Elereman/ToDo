import 'package:ToDo/core/tools/settings_provider/settings_provider.dart';
import 'package:ToDo/core/tools/settings_provider/settings_provider_state.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/get_settings_list.dart';

class GetSettingsListUseCaseThroughRepository
    implements GetSettingsListUseCase {
  final SettingsProvider _settingsProvider;

  GetSettingsListUseCaseThroughRepository(this._settingsProvider);

  @override
  Future<Map<String, Setting<String>>> call() async {
    await _settingsProvider.requireAllSettings();
    final SettingsProviderState _settingsState =
        await _settingsProvider.stateStream.first;
    return _settingsState.settings;
  }
}
