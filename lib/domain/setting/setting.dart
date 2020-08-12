class Setting<T> {
  final T _key;
  final T _setting;

  Setting(this._key, this._setting);

  T get setting => _setting;

  T get key => _key;
}