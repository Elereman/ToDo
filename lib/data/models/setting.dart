class SettingModel {
  final String _key;
  final String _setting;

  SettingModel(this._key, this._setting);

  String get setting => _setting;

  String get key => _key;
}
