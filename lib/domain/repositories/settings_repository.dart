import 'file:///D:/ToDo/lib/domain/entities/setting.dart';

abstract class SettingsRepository {
  Future<void> initialize();

  Future<Setting<String>> update(Setting<String> setting);

  Future<bool> reset(Setting<String> setting);

  Future<bool> resetAll();

  Future<Setting<String>> read(Setting<String> setting);

  Future<List<Setting<String>>> readAll();
}
