import 'package:ToDo/domain/entities/setting.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/bloc.dart';
import 'package:ToDo/presentation/blocs/settings_drawer/state.dart';
import 'package:flutter/material.dart';
import 'package:ToDo/core/tools/bool_parsing.dart';

import 'color_chose_dialog.dart';

class SettingsDrawer extends StatelessWidget {
  final List<Color> _colorPalette;
  final Function _onDeleteAllButton;
  final Function(BuildContext context) _onThemeSwitch;
  final SettingsDrawerBloc _bloc;

  const SettingsDrawer(
      {Key key,
      Function onDeleteAllButton,
      List<Color> colorPalette,
      Function(BuildContext context) onThemeSwitch,
      SettingsDrawerBloc bloc})
      : _onDeleteAllButton = onDeleteAllButton,
        _colorPalette = colorPalette,
        _onThemeSwitch = onThemeSwitch,
        _bloc = bloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: StreamBuilder<SettingsDrawerState>(
            stream: _bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<SettingsDrawerState> snapshot) {
              _bloc.getSettingsList();
              if (snapshot.hasData) {
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
                              value: snapshot.data.settings
                                      .containsKey('dark_mode') &&
                                  snapshot.data.settings['dark_mode'].setting
                                      .parseBool(),
                              onChanged: _isDarkModeEnable(context)
                                  ? null
                                  : (bool value) =>
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
                                          colorPalette: _colorPalette,
                                          label: 'Chose task color',
                                          defaultColor: snapshot.data.settings
                                                  .containsKey('task_color')
                                              ? _parseColorFromString(snapshot
                                                  .data
                                                  .settings['task_color']
                                                  .setting)
                                              : _colorPalette[0]))
                                  .then(
                                      (Color color) => _changeTaskColor(color));
                            },
                            color:
                                snapshot.data.settings.containsKey('task_color')
                                    ? _parseColorFromString(snapshot
                                        .data.settings['task_color'].setting)
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
                                          colorPalette: _colorPalette,
                                          label: 'Chose description color',
                                          defaultColor: snapshot.data.settings
                                                  .containsKey(
                                                      'description_color')
                                              ? _parseColorFromString(snapshot
                                                  .data
                                                  .settings['description_color']
                                                  .setting)
                                              : _colorPalette[1]))
                                  .then((Color color) =>
                                      _changeDescriptionColor(color));
                            },
                            color: snapshot.data.settings
                                    .containsKey('description_color')
                                ? _parseColorFromString(snapshot
                                    .data.settings['description_color'].setting)
                                : _colorPalette[1],
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: Theme.of(context).bottomAppBarColor,
                      child: const Text('Restore defaults'),
                      onPressed: () {
                        _bloc.resetSettings();
                        _onThemeSwitch(context);
                      },
                    ),
                    MaterialButton(
                      color: Theme.of(context).bottomAppBarColor,
                      child: const Text('Delete all tasks'),
                      onPressed: () => _onDeleteAllButton(),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  bool _isDarkModeEnable(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  Future<Color> _showColorChoseDialog(
          BuildContext context, ColorChooseDialog colorChooseDialog) async =>
      showDialog<Color>(
          context: context,
          builder: (BuildContext context) => colorChooseDialog);

  void _changeTaskColor(Color color) {
    _bloc.editSetting(Setting<String>('task_color', color.value.toString()));
  }

  void _changeDescriptionColor(Color color) {
    _bloc.editSetting(
        Setting<String>('description_color', color.value.toString()));
  }

  void _changeTheme(bool value, BuildContext context) {
    _bloc.editSetting(Setting<String>('dark_mode', value.toString()));
    _onThemeSwitch(context);
  }

  Color _parseColorFromString(String str) {
    return Color(int.parse(str));
  }
}
