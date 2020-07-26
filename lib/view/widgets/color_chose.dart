import 'package:flutter/material.dart';

class ColorChoose extends StatelessWidget {
  final List<Color> colors;
  final void Function(Color) function;
  final String label;

  Color _color = Colors.cyan;

  ColorChoose(
      {Key key,
      @required this.colors,
      @required this.function,
      @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 170,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Container(
                child: Text(label),
                alignment: Alignment.center,
              ),
            ),
            Wrap(
              spacing: 5,
              children: [..._generateFromColors(colors)],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal : 8.0),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      function(_color);
                      _closeDialog(context);
                    },
                    color: Colors.green,
                    child: Text('Save'),
                  ),
                  Spacer(),
                  MaterialButton(
                    onPressed: () => _closeDialog(context),
                    color: Colors.red,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(this);
  }

  List<RaisedButton> _generateFromColors(
      List<Color> colors) {
    List<RaisedButton> result = [];
    colors.forEach((element) {
      MaterialButton button;
      button = RaisedButton(
        onPressed: () => _color = element,
        color: element,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
      result.add(button);
    });
    return result;
  }

  Color get chosenColor => _color;
}
