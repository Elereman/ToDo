import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/settings_drawer.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:ToDo/domain/setting/setting.dart';
import 'package:ToDo/flutter/view/widgets/color_chose_dialog.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  final List<Color> _colorPalette;
  final Function _onClearAllButton;
  final Function(BuildContext context) _onThemeSwitch;
  final SettingsDrawerBloc _bloc;

  const SettingsDrawer(this._colorPalette, this._onClearAllButton,
      this._onThemeSwitch, this._bloc,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _sendEventToBloc(SettingsBuildEvent());
    return Drawer(
      child: SafeArea(
        child: StreamBuilder<BlocState<dynamic>>(
            stream: _bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<BlocState<dynamic>> snapshot) {
              final List<Setting<String>> _settings =
                  _getSettingListFromSnapshot(snapshot);
              final Map<String, String> _settingsMap =
                  _listSettingsToMap(_settings);
              print('settings:::::::::::::::::: $_settings');
              print('dark mode:::::::::::::::::: ${_settingsMap['dark_mode']}');
              print(
                  'dark mode switch position ${toBoolean(_settingsMap['dark_mode'])}');
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).bottomAppBarColor,
                    child: const Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.brush),
                    title: Row(
                      children: <Widget>[
                        const Text('Dark theme'),
                        const Spacer(),
                        Switch(
                            value: _settingsMap.containsKey('dark_mode') &&
                                toBoolean(_settingsMap['dark_mode']),
                            onChanged: _isDarkModeEnable(context) ? null : (bool value) =>
                                _changeTheme(value, context)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.text_format),
                    title: Row(
                      children: <Widget>[
                        const Text('Task color'),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            _showColorChoseDialog(
                                context,
                                ColorChooseDialog(
                                    colors: _colorPalette,
                                    onColorChosen: _changeTaskColor,
                                    label: 'Chose task color',
                                    defaultColor: _settingsMap
                                            .containsKey('task_color')
                                        ? toColor(_settingsMap['task_color'])
                                        : _colorPalette[0]));
                          },
                          color: _settingsMap.containsKey('task_color')
                              ? toColor(_settingsMap['task_color'])
                              : _colorPalette[0],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.text_format),
                    title: Row(
                      children: <Widget>[
                        const Text('Description color'),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            _showColorChoseDialog(
                                context,
                                ColorChooseDialog(
                                    colors: _colorPalette,
                                    onColorChosen: _changeDescriptionColor,
                                    label: 'Chose description color',
                                    defaultColor: _settingsMap
                                            .containsKey('description_color')
                                        ? toColor(
                                            _settingsMap['description_color'])
                                        : _colorPalette[1]));
                          },
                          color: _settingsMap.containsKey('description_color')
                              ? toColor(_settingsMap['description_color'])
                              : _colorPalette[1],
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).bottomAppBarColor,
                    child: const Text('Restore defaults'),
                    onPressed: () {
                      _sendEventToBloc(SettingsResetPressedEvent());
                      _onThemeSwitch(context);
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).bottomAppBarColor,
                    child: const Text('Delete all tasks'),
                    onPressed: () => _onClearAllButton(),
                  ),
                ],
              );
            }),
      ),
    );
  }

  bool _isDarkModeEnable(BuildContext context) {
    if(MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  Future<ColorChooseDialog> _showColorChoseDialog(
      BuildContext context, ColorChooseDialog colorChooseDialog) async {
    return await showDialog(context: context, child: colorChooseDialog);
  }

  void _sendEventToBloc(BlocEvent event) {
    _bloc.eventSink.add(event);
  }

  void _changeTaskColor(Color color) {
    _sendEventToBloc(SettingsChangedPressedEvent(
        data: Setting<String>('task_color', color.value.toString())));
  }

  void _changeDescriptionColor(Color color) {
    _sendEventToBloc(SettingsChangedPressedEvent(
        data: Setting<String>('description_color', color.value.toString())));
  }

  void _changeTheme(bool value, BuildContext context) {
    _sendEventToBloc(SettingsChangedPressedEvent(
        data: Setting<String>('dark_mode', value.toString())));
    _onThemeSwitch(context);
  }

  List<Setting<String>> _getSettingListFromSnapshot(
      AsyncSnapshot<BlocState<dynamic>> snapshot) {
    final List<Setting<String>> _result = <Setting<String>>[];
    if (snapshot.hasData && snapshot.data != null) {
      if (snapshot.data is SettingsChangedState<List<Setting<String>>>) {
        _result.addAll(snapshot.data.stateData as List<Setting<String>>);
      }
    }
    return _result;
  }

  Map<String, String> _listSettingsToMap(List<Setting<String>> settings) {
    final Map<String, String> _result = <String, String>{};
    settings.forEach((Setting<String> element) {
      _result.putIfAbsent(element.key, () => element.setting);
    });
    return _result;
  }

  bool toBoolean(String str) {
    if (str == 'true') {
      return true;
    } else {
      return false;
    }
  }

  Color toColor(String str) {
    return Color(int.parse(str));
  }
}
