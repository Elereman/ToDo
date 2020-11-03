import 'package:ToDo/core/assembly/abstract/setting_entity.dart';
import 'package:ToDo/data/models/setting.dart';
import 'package:ToDo/data/repository/shared_preferences_settings/datasources/shared_preferences.dart';
import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/domain/repositories/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final Map<String, String> _defaults;
  final SettingSharedPreferencesDataSource _dataSource;
  final SettingEntityFactory _factory;

  SharedPreferencesSettingsRepository(
      Map<String, String> defaultSettings, this._factory)
      : _defaults = defaultSettings,
        _dataSource = SettingSharedPreferencesDataSource(defaultSettings),
        super() {
    initialize();
  }

  Future<void> initialize() => _dataSource.initialize();

  @override
  Future<Setting<String>> update(Setting<String> setting) async =>
      _factory.create(
          await _dataSource.update(SettingModel(setting.key, setting.setting)));

  @override
  Future<bool> reset(Setting<String> setting) => _dataSource.resetAll();

  @override
  Future<Setting<String>> read(String setting) async =>
      _factory.create(await _dataSource.read(setting));

  @override
  Future<bool> resetAll() => _dataSource.resetAll();

  @override
  Future<Map<String, Setting<String>>> readAll() async {
    final Map<String, Setting<String>> result = <String, Setting<String>>{};
    _defaults.forEach((String key, String value) async {
      result[key] = await read(key);
    });
    return result;
  }
}
