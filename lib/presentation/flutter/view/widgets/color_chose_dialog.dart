import 'package:flutter/material.dart';

class ColorChooseDialog extends StatelessWidget {
  final List<Color> _colorPalette;
  final void Function(Color) _onColorChosen;
  final String _label;
  final Color _defaultColor;

  const ColorChooseDialog(
      {@required List<Color> colorPalette,
      @required void Function(Color) onColorChosen,
      @required String label,
      @required Color defaultColor,
      Key key,})
      : _colorPalette = colorPalette,
        _onColorChosen = onColorChosen,
        _label = label,
        _defaultColor = defaultColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              child: Text(_label),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 5,
              children: <MaterialButton>[
                ..._generateFromColors(_colorPalette, context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  Color get defaultColor => _defaultColor;

  List<MaterialButton> _generateFromColors(
      List<Color> colors, BuildContext context) {
    final List<MaterialButton> result = <MaterialButton>[];
    colors.forEach((Color _color) {
      MaterialButton button;
      button = RaisedButton(
        onPressed: () {
          _onColorChosen(_color);
          _closeDialog(context);
        },
        color: _color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
      result.add(button);
    });
    return result;
  }
}
