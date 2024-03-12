import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileModel {
  final File file; //SENDING,SUCCESS,FAILED
  final String uploadedUrl;

  FileModel({
    required this.file,
    required this.uploadedUrl,
  });
}

class FileContent {
  final FileType fileType;
  final String contentType;
  final String contentText;

  FileContent({
    required this.fileType,
    required this.contentType,
    required this.contentText,
  });
}

class FileUtils {
  static final FileUtils instance = FileUtils._init();

  FileUtils._init();

  Future<File> saveFileToDocumentsDirectory(File file, String extension) async {
    // 生成UUID
    var uuid = const Uuid().v4();
    // 解析UUID以创建目录结构
    String dirPath =
        '${uuid[0]}/${uuid.substring(0, 2)}/${uuid.substring(0, 8)}';

    // 获取文档目录并生成最终的保存路径
    Directory docDir = await getApplicationDocumentsDirectory();
    String fullPath = p.join(docDir.path, dirPath);

    // 检查目录是否存在，不存在则创建
    final directory = Directory(fullPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    // 定义文件的最终路径（包括新的文件名）
    String filePath = p.join(fullPath, "$uuid$extension");

    // 复制文件到新路径
    return await file.copy(filePath);
  }

  Future<List<File>> directlyOpenFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    }
    return [];
  }

  Future<FileModel?> copyAndSendFile(File file) async {
    print("Upload file: ${file.path}");
    String extension = p.extension(file.path);
    try {
      File savedFile = await saveFileToDocumentsDirectory(file, extension);
      String fileUrl = 'AfterUploaded$extension';
      FileModel fileModel = FileModel(file: savedFile, uploadedUrl: fileUrl);
      return fileModel;
    } catch (e) {
      print(e);
    }
    return null;
  }

  FileContent getContentTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return FileContent(
            fileType: FileType.image,
            contentType: 'IMAGE',
            contentText: '[图片]');
      case '.mp4':
      case '.avi':
      case '.mov':
        return FileContent(
            fileType: FileType.video,
            contentType: 'VIDEO',
            contentText: '[视频]');
      case '.mp3':
      case '.wav':
        return FileContent(
            fileType: FileType.audio,
            contentType: 'AUDIO',
            contentText: '[音频]');
      default:
        return FileContent(
            fileType: FileType.custom,
            contentType: 'FILE',
            contentText: '[文件]');
    }
  }
}
