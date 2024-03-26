import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ImageVideoPicker extends StatefulWidget {
  @override
  _ImageVideoPickerState createState() => _ImageVideoPickerState();
}

class _ImageVideoPickerState extends State<ImageVideoPicker> {
  List<File> _selectedFiles = [];

  Future<void> _pickFiles(FileType type) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: type,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _selectedFiles = files;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: '图片'),
              Tab(text: '视频'),
            ],
          ),
          title: Text('选择文件'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _pickFiles(FileType.image),
                child: Text('选择图片'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _pickFiles(FileType.video),
                child: Text('选择视频'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
