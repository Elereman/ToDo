import 'package:ToDo/core/assembly/abstract/setting_entity.dart';
import 'package:ToDo/data/models/setting.dart';
import 'package:ToDo/domain/entities/setting.dart';

class SettingEntityFromModelFactory implements SettingEntityFactory {
  @override
  Setting<String> create(SettingModel argument) =>
      Setting<String>(argument.key, argument.setting);
}
