import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // 添加筛选条件的状态变量
  int selectedGenderIndex = 0; // 性别选项
  int selectedStatusIndex = 0; // 状态选项

  // 性别选项
  final List<String> genderOptions = ['不限', '男', '女'];

  // 状态选项
  final List<String> statusOptions = ['不限', '在线优先', '附近用户'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 280), // 设置最大高度
      child: Column(
        children: <Widget>[
          const Text(
            '筛选设置',
            style: TextStyle(
              fontSize: 18, // 设置字号
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start, // 左右对齐
            children: <Widget>[
              SizedBox(width: 4),
              Text('性别', style: TextStyle(fontSize: 16)), // 调整字体大小
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 间隔分布
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGenderIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedGenderIndex == 0
                      ? Colors.indigoAccent
                      : Colors.white70, // 根据选中状态设置背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角样式
                  ),
                ),
                child: Text(
                  '不限',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedGenderIndex == 0
                        ? Colors.white
                        : Colors.black, // 根据选中状态设置文本颜色
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGenderIndex = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedGenderIndex == 1
                      ? Colors.indigoAccent
                      : Colors.white70, // 根据选中状态设置背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('男',
                    style: TextStyle(
                        fontSize: 16,
                        color: selectedGenderIndex == 1
                            ? Colors.white
                            : Colors.black)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGenderIndex = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedGenderIndex == 2
                      ? Colors.indigoAccent
                      : Colors.white70, // 根据选中状态设置背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('女',
                    style: TextStyle(
                        fontSize: 16,
                        color: selectedGenderIndex == 2
                            ? Colors.white
                            : Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start, // 左右对齐
            children: <Widget>[
              SizedBox(width: 4),
              Text('状态', style: TextStyle(fontSize: 16)), // 调整字体大小
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedStatusIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedStatusIndex == 0
                      ? Colors.indigoAccent
                      : Colors.white70, // 根据选中状态设置背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '不限',
                  style: TextStyle(
                      fontSize: 16,
                      color: selectedStatusIndex == 0
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedStatusIndex = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedStatusIndex == 1
                      ? Colors.indigoAccent
                      : Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('在线优先',
                    style: TextStyle(
                        fontSize: 16,
                        color: selectedStatusIndex == 1
                            ? Colors.white
                            : Colors.black)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedStatusIndex = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 36),
                  backgroundColor: selectedStatusIndex == 1
                      ? Colors.indigoAccent
                      : Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '附近用户',
                  style: TextStyle(
                      fontSize: 16,
                      color: selectedStatusIndex == 2
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 4, // 分配 2 个单位的空间给第一个按钮
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedGenderIndex = 0;
                        selectedStatusIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const SizedBox(
                      height: 48,
                      child: Center(
                        child: Text(
                          '重置',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                flex: 6, // 分配 8 个单位的空间给第二个按钮
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.indigoAccent, // 根据条件设置背景颜色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        '确认',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
