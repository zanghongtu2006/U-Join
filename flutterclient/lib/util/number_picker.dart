import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNumberPicker extends StatefulWidget {
  final String title;
  final int minValue;
  final int maxValue;
  final String unit;
  final int initialValue;
  final Function(int) onConfirm;

  CustomNumberPicker({
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.initialValue,
    required this.onConfirm,
  });

  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32.0,
              magnification: 1.22,
              useMagnifier: true,
              onSelectedItemChanged: (int index) {
                selectedValue = widget.minValue + index;
              },
              children: List<Widget>.generate(
                widget.maxValue - widget.minValue + 1,
                (int index) {
                  return Center(
                    child: Text(
                      '${widget.minValue + index} ${widget.unit}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                    '取消', Colors.grey, () => Navigator.of(context).pop()),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildButton('确认', Colors.indigoAccent, () {
                  widget.onConfirm(selectedValue);
                  Navigator.of(context).pop();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String title, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
