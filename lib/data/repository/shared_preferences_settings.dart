import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final Map<String, String> defaults = <String, String>{
    'task_color': '4278190080',
    'description_color': '4288585374',
    'dark_mode': 'false',
  };

  SharedPreferencesSettingsRepository() {
    initialize();
  }

  Future<void> initialize() async {
    final SharedPreferences preferences = await _prefs;
    defaults.forEach((String key, String value) async {
      if (preferences.getString(key) == null) {
        await resetAll();
      }
    });
    return;
  }

  @override
  Future<Setting<String>> update(Setting<String> setting) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(setting.key, setting.setting);
    return setting;
  }

  @override
  Future<bool> reset(Setting<String> setting) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(setting.key, defaults[setting.key]);
    return true;
  }

  @override
  Future<Setting<String>> read(String setting) async {
    final SharedPreferences preferences = await _prefs;
    return Setting<String>(setting, preferences.getString(setting));
  }

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<bool> resetAll() async {
    final SharedPreferences preferences = await _prefs;
    defaults.forEach((String key, String value) async {
      preferences.setString(key, value);
    });
    return true;
  }

  @override
  Future<Map<String, Setting<String>>> readAll() async {
    final Map<String, Setting<String>> result = <String, Setting<String>>{};
    defaults.forEach((String key, String value) async {
      result[key] = await read(key);
    });
    return result;
  }
}
