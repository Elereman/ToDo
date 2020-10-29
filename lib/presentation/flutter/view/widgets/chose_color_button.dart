import 'package:ToDo/presentation/flutter/view/widgets/color_chose_dialog.dart';
import 'package:flutter/material.dart';

class ChoseColorButton extends StatefulWidget {
  final Function(Color) _onColorChosen;
  final Color _startColor;
  final String _buttonText;
  final String _colorChooserLabel;

  final List<Color> _colorPalette;

  const ChoseColorButton({
    @required Function(Color) onColorChosen,
    @required Color startColor,
    @required String buttonText,
    @required String colorChooserLabel,
    List<Color> colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  })  : _onColorChosen = onColorChosen,
        _startColor = startColor,
        _buttonText = buttonText,
        _colorChooserLabel = colorChooserLabel,
        _colorPalette = colorPalette,
        super();

  @override
  _ChoseColorButtonState createState() => _ChoseColorButtonState(_startColor);
}

class _ChoseColorButtonState extends State<ChoseColorButton> {
  Color _color;

  _ChoseColorButtonState(this._color);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: _color,
      child: Text(widget._buttonText),
      onPressed: () {
        _showColorPicker(context).then((ColorChooseDialog dialog) {
          setState(() {});
        });
      },
    );
  }

  Future<ColorChooseDialog> _showColorPicker(BuildContext context) async {
    return showDialog<ColorChooseDialog>(
      context: context,
      child: ColorChooseDialog(
        defaultColor: widget._startColor,
        label: widget._colorChooserLabel,
        colorPalette: widget._colorPalette,
        onColorChosen: (Color color) {
          _color = color;
          widget._onColorChosen(color);
        },
      ),
    );
  }
}
