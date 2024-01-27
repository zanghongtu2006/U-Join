import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onConfirm;

  CustomDatePicker({required this.onConfirm});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime currentDate = DateTime.now();
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
  int startYear = 1950;
  int endYear = 2024 - 18;

  @override
  void initState() {
    super.initState();
    selectedYear = currentDate.year;
    selectedMonth = currentDate.month;
    selectedDay = currentDate.day;
    startYear = DateTime.now().year - 80;
    endYear =  DateTime.now().year - 18;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.onConfirm);
    return Container(
      height: 250,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPicker('Year', selectedYear, startYear, endYear, (int index) {
                  selectedYear = startYear + index;
                  _adjustSelectedDay();
                }),
                _buildPicker('Month', selectedMonth, 1, 12, (int index) {
                  selectedMonth = 1 + index;
                  _adjustSelectedDay();
                }),
                _buildPicker('Day', selectedDay, 1, _daysInMonth(selectedYear, selectedMonth), (int index) {
                  selectedDay = 1 + index;
                }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width:16),
              Expanded(child: _buildButton('取消', Colors.grey, () => Navigator.of(context).pop())),
              SizedBox(width: 16), // 按钮之间的空白
              Expanded(child: _buildButton('确认', Colors.indigoAccent, () {
                widget.onConfirm(DateTime(selectedYear, selectedMonth, selectedDay));
                Navigator.of(context).pop();
              })),
              SizedBox(width:16),
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
        backgroundColor: color, // 按钮背景色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 圆角
        ),
        elevation: 0, // 取消阴影效果
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white), // 文字颜色
      ),
    );
  }

  Widget _buildPicker(String type, int currentValue, int minValue, int maxValue, ValueChanged<int> onChanged) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: currentValue - minValue),
        onSelectedItemChanged: onChanged,
        children: List<Widget>.generate(maxValue - minValue + 1, (int index) {
          return Center(
            child: Text(
              '${minValue + index}',
              style: TextStyle(fontSize: 16),
            ),
          );
        }),
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _adjustSelectedDay() {
    final int daysInMonth = _daysInMonth(selectedYear, selectedMonth);
    setState(() {
      selectedDay = selectedDay > daysInMonth ? daysInMonth : selectedDay;
    });
  }
}
