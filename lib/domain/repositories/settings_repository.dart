import 'package:ToDo/domain/entities/setting.dart';

abstract class SettingsRepository {
  Future<Setting<String>> update(Setting<String> setting);

  Future<bool> reset(Setting<String> setting);

  Future<bool> resetAll();

  Future<Setting<String>> read(String setting);

  Future<Map<String, Setting<String>>> readAll();
}
