import 'package:flutter/material.dart';

class FilterButtons extends StatefulWidget {
  final Function(int) onSelected; // 点击文本按钮时的回调
  final VoidCallback onFilter; // 点击筛选按钮时的回调

  FilterButtons({Key? key, required this.onSelected, required this.onFilter}) : super(key: key);

  @override
  _FilterButtonsState createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  int _selectedButtonIndex = 0; // 当前选中的文本按钮索引
  final List<String> _filters = ['全部', '附近', '新人', '名人']; // 固定筛选条件

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // 两端对齐
      children: <Widget>[
        ...List.generate(_filters.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0), // 减少按钮之间的水平间距
            child: TextButton(
              onPressed: () {
                setState(() => _selectedButtonIndex = index);
                widget.onSelected(index);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0.0), // 减少按钮内边距
                minimumSize: const Size(0, 0)
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: _selectedButtonIndex == index ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        }),
        const Spacer(), // 用于将文本按钮和筛选按钮分开
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: widget.onFilter,
        ),
      ],
    );
  }
}
