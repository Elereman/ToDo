class SettingModel {
  final String _key;
  final String _setting;

  SettingModel._(this._key, this._setting);

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel._(json['key'] as String, json['setting'] as String);
  }

  String get setting => _setting;

  String get key => _key;
}