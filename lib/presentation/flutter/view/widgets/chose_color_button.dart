import 'package:ToDo/presentation/flutter/view/widgets/color_chose_dialog.dart';
import 'package:flutter/material.dart';

class ChoseColorButton extends StatefulWidget {
  final Color _startColor;
  final String _buttonText;
  final String _colorChooserLabel;

  final List<Color> _colorPalette;

  final Function(Color) _onColorChosen;

  const ChoseColorButton({
    @required Color startColor,
    @required String buttonText,
    @required String colorChooserLabel,
    @required Function(Color) onColorChosen,
    List<Color> colorPalette = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blueAccent,
      Colors.orange,
      Colors.indigo,
    ],
  })
      : _startColor = startColor,
        _buttonText = buttonText,
        _colorChooserLabel = colorChooserLabel,
        _colorPalette = colorPalette,
        _onColorChosen = onColorChosen,
        super();

  @override
  _ChoseColorButtonState createState() =>
      _ChoseColorButtonState(_startColor, _onColorChosen);
}

class _ChoseColorButtonState extends State<ChoseColorButton> {
  Color _color;
  final Function(Color) _onColorChosen;

  _ChoseColorButtonState(this._color, this._onColorChosen);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: _color,
      child: Text(widget._buttonText),
      onPressed: () {
        _showColorPicker(context).then((Color color) {
          setState(() {
            _color = color;
          });
          _onColorChosen(color);
        });
      },
    );
  }

  Future<Color> _showColorPicker(BuildContext context) async {
    return showDialog<Color>(
      context: context,
      child: ColorChooseDialog(
        defaultColor: widget._startColor,
        label: widget._colorChooserLabel,
        colorPalette: widget._colorPalette,
      ),
    );
  }
}
