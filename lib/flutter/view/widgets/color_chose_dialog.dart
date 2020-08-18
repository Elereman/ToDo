import 'package:flutter/material.dart';

class ColorChooseDialog extends StatelessWidget {
  final List<Color> colors;
  final void Function(Color) onColorChosen;
  final String label;
  final Color defaultColor;
  final Color color;

  const ColorChooseDialog(
      {@required this.colors,
      @required this.onColorChosen,
      @required this.label,
      @required this.defaultColor,
      Key key,
      this.color = Colors.cyan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              child: Text(label),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 5,
              children: <MaterialButton>[..._generateFromColors(colors, context)],
            ),
          ),
        ],
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  List<MaterialButton> _generateFromColors(List<Color> colors, BuildContext context) {
    final List<MaterialButton> result = <MaterialButton>[];
    colors.forEach((Color element) {
      MaterialButton button;
      button = RaisedButton(
        onPressed: () {
          //color = element;
          onColorChosen(element);
          _closeDialog(context);
          },
        color: element,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
      result.add(button);
    });
    return result;
  }

  //Color get chosenColor => color;
}