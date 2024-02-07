import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/profile/personality_tag.dart';
import 'package:flutterclient/util/api_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../util/date_picker.dart';
import '../../../util/number_picker.dart';
import 'progress.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final _nicknameController = TextEditingController();
  String _gender = ''; // 'male' or 'female'
  String nickname = '';
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int height = 170; // 默认身高，可根据需要调整
  int weight = 60; // 默认体重，可根据需要调整
  int minHeight = 100; // 最小身高
  int maxHeight = 220; // 最大身高
  int minWeight = 30; // 最小体重
  int maxWeight = 200; // 最大体重
  // 假设这里是性别图标的路径
  final String _maleIconGrey = 'assets/mine/icon_perfect_info_man_nor.png';
  final String _maleIconColor = 'assets/mine/icon_perfect_info_man_sel.png';
  final String _femaleIconGrey = 'assets/mine/icon_perfect_info_woman_nor.png';
  final String _femaleIconColor = 'assets/mine/icon_perfect_info_woman_sel.png';

  DateTime selectedDate = DateTime.now();

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return CustomDatePicker(onConfirm: (DateTime selectedDate) {
          setState(() {
            // 更新选定的日期
            this.selectedDate = selectedDate;
          });
        });
      },
    );
  }

  void _showHeightPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CustomNumberPicker(
          title: '身高',
          minValue: minHeight,
          maxValue: maxHeight,
          unit: 'cm',
          initialValue: height,
          onConfirm: (int value) {
            setState(() {
              height = value;
            });
          },
        );
      },
    );
  }

  void _showWeightPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CustomNumberPicker(
          title: '体重',
          minValue: minWeight,
          maxValue: maxWeight,
          unit: 'kg',
          initialValue: weight,
          onConfirm: (int value) {
            setState(() {
              weight = value;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mine/bg_color.png'), // 图片路径
              fit: BoxFit.cover, // 填充模式
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 240,
                    child: CustomStepProgress(
                        totalSteps: 4,
                        currentStep: 1,
                        activeColor: Colors.indigoAccent,
                        inactiveColor: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text('完善个人资料',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('认真填写，把你推荐给最适合的那个Ta~',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('你的性别',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('*性别选择后不可更改',
                          style: TextStyle(fontSize: 10, color: Colors.red)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => setState(() => _gender = 'MALE'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            _gender == 'MALE' ? _maleIconColor : _maleIconGrey,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () => setState(() => _gender = 'FEMALE'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                              _gender == 'FEMALE'
                                  ? _femaleIconColor
                                  : _femaleIconGrey,
                              width: 80),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      const Expanded(flex: 1, child: Text("昵称")),
                      Expanded(
                        flex: 5,
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: '请输入您的昵称',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero),
                          onChanged: (value) {
                            setState(() {
                              nickname = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _showDatePicker(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 1, child: Text("生日")),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _showHeightPicker(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 1, child: Text("身高")),
                          Expanded(
                            flex: 4,
                            child: Text(
                              height.toString(),
                              style: const TextStyle(color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _showWeightPicker(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 1, child: Text("体重")),
                          Expanded(
                            flex: 4,
                            child: Text(
                              weight.toString(),
                              style: const TextStyle(color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (nickname.isEmpty) {
                // 显示一个提示信息
                showToast('昵称不能为空',
                    duration: const Duration(seconds: 2),
                    position: ToastPosition.bottom,
                    backgroundColor: Colors.black12,
                    textPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    textStyle: const TextStyle(color: Colors.black));
                return;
              }
              if (_gender.isEmpty) {
                // 显示一个提示信息
                showToast('性别不能为空',
                    duration: const Duration(seconds: 2),
                    position: ToastPosition.bottom,
                    backgroundColor: Colors.black12,
                    textPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    textStyle: const TextStyle(color: Colors.black));
                return;
              }
              var response = await ApiService().post(
                '/mine/profile',
                {
                  'nickName': nickname,
                  'birthDate': selectedDate.millisecondsSinceEpoch,
                  'gender': _gender,
                  'height': height,
                  'weight': weight
                },
              );
              if (response.statusCode == 200) {
                var data = json.decode(response.body);
                if (data['code'] == 0) {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => PersonalityTagPage(),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent, // 按钮背景色
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 圆角
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0), // 垂直填充
              elevation: 0,
            ),
            child: const Text(
              "下一步",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
