import 'package:ToDo/data/models/setting.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingSharedPreferencesDataSource {
  final Map<String, String> _defaults;

  SettingSharedPreferencesDataSource(this._defaults);

  Future<void> initialize() async {
    final SharedPreferences preferences = await _prefs;
    _defaults.forEach((String key, String value) async {
      if (preferences.getString(key) == null) {
        await resetAll();
      }
    });
    return;
  }

  Future<SettingModel> update(SettingModel setting) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(setting.key, setting.setting);
    return setting;
  }

  Future<bool> reset(Setting<String> setting) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(setting.key, _defaults[setting.key]);
    return true;
  }

  Future<SettingModel> read(String setting) async {
    final SharedPreferences preferences = await _prefs;
    return SettingModel(setting, preferences.getString(setting));
  }

  Future<bool> resetAll() async {
    final SharedPreferences preferences = await _prefs;
    _defaults.forEach((String key, String value) async {
      preferences.setString(key, value);
    });
    return true;
  }

  Future<Map<String, SettingModel>> readAll() async {
    final Map<String, SettingModel> result = <String, SettingModel>{};
    _defaults.forEach((String key, String value) async {
      result[key] = await read(key);
    });
    return result;
  }

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();
}
