import 'package:ToDo/core/tools/settings_provider/settings_provider.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/usecases/edit_setting.dart';

class EditSettingUseCaseThroughRepository implements EditSettingUseCase {
  final SettingsProvider _settingsProvider;

  EditSettingUseCaseThroughRepository(this._settingsProvider);

  @override
  Future<Setting<String>> call(Setting<String> setting) async {
    await _settingsProvider.requireAllSettings();
    _settingsProvider.editSetting(setting);
    return _settingsProvider.editSetting(setting);
  }
}
