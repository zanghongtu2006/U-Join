import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../page/login/login_page.dart';

class ApiService {
  Dio dio = Dio();

  ApiService() {
    // 配置 Dio 实例
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.statusCode == 401) {
          // 处理未授权的逻辑
          print('Unauthorized request');
          // 导航到登录页等操作
          navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
        }
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // 处理错误
        print(e.message);
        return handler.next(e);
      },
    ));
  }

  // 示例: 发送 GET 请求
  Future<Response> fetchData(String url) async {
    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// 在这里可以添加更多的网络请求方法
}
