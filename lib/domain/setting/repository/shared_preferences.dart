import 'package:ToDo/domain/setting/repository/repository.dart';
import 'package:ToDo/domain/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final Map<String, String> defaults = <String, String>{
    'task_color':'4278190080',
    'description_color':'4288585374',
    'dark_mode':'false',
  };

  @override
  Future<void> initialize() async {
    final SharedPreferences preferences = await _prefs;
    defaults.forEach((String key, String value) async {
      if(preferences.getString(key) == null) {
        await resetAll();
      }
      print('Setting:::::: ${preferences.getString(key)}');
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
  Future<Setting<String>> read(Setting<String> setting) async {
    final SharedPreferences preferences = await _prefs;
    return Setting<String>(setting.key, preferences.getString(setting.key));
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
  Future<List<Setting<String>>> readAll() async {
    final List<Setting<String>> result = <Setting<String>>[];
    defaults.forEach((String key, String value) async {
      result.add(await read(Setting<String>(key, '')));
    });
    return result;
  }
}