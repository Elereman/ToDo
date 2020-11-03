import 'package:ToDo/data/models/setting.dart';
import 'package:ToDo/domain/entities/setting.dart';

import 'entity_factory.dart';

abstract class SettingEntityFactory
    implements EntityFactory<Setting<String>, SettingModel> {}
