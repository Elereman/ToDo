import 'package:ToDo/view/widgets/color_chose.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  final List<Color> _colorPalette;
  final Function _onClearAllButton;

  const SettingsDrawer(this._colorPalette, this._onClearAllButton, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
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
                  Switch(value: false, onChanged: (bool value) => print(value)),
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
                      _showColorChoseDialog(context, null);
                    },
                    color: _colorPalette[0],
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
                      _showColorChoseDialog(context, null);
                    },
                    color: _colorPalette[0],
                  ),
                ],
              ),
            ),
            MaterialButton(
              color: Theme.of(context).bottomAppBarColor,
              child: const Text('Restore defaults'),
              onPressed: () => print('Restored'),
            ),
            MaterialButton(
              color: Theme.of(context).bottomAppBarColor,
              child: const Text('Delete all tasks'),
              onPressed: () => _onClearAllButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<ColorChoose> _showColorChoseDialog(
      BuildContext context, ColorChoose colorChoose) async {
    return await showDialog(context: context, child: colorChoose);
  }
}
