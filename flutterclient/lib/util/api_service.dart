import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';

import '../main.dart';

class ApiService {
  final String baseUrl;
  final storage = const FlutterSecureStorage();
  final timeout = 10;

  ApiService({this.baseUrl = 'http://192.168.168.10:8080'});

  Future<void> setToken(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> _getToken() async {
    return getToken();
  }

  Future<String?> getToken() async {
    try {
      String? token = await storage.read(key: 'access_token');
      print("Retrieved token: $token"); // 调试信息
      return token ?? '';
    } catch (e) {
      print("Error getting token: $e"); // 错误处理
      return '';
    }
  }

  Future<void> _clearToken() async {
    await storage.deleteAll();
  }

  Future<void> clearToken() async {
    await storage.deleteAll();
  }

  Future<http.Response> get(String endpoint,
      {Map<String, dynamic>? params}) async {
    var token = await _getToken();
    // 构建带参数的 URL
    var uri = Uri.parse('$baseUrl$endpoint');
    // 如果传递了参数，则将参数添加到 URL 中
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(queryParameters: params);
    }
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    var token = await _getToken();
    print(json.encode(data));
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response);
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    var token = await _getToken();
    final response = await http
        .put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    )
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response);
  }

  Future<http.Response> delete(String endpoint, dynamic data) async {
    var token = await _getToken();
    final response = await http
        .delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    )
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response);
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      _clearToken();
      // 这里需要添加跳转到登录界面的代码
      navigatorKey.currentState?.pushReplacementNamed('/login');
    } else if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['code'] != 0) {
        showToast(result['msg'],
            duration: const Duration(seconds: 2),
            position: ToastPosition.bottom,
            backgroundColor: Colors.black12,
            textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            textStyle: const TextStyle(color: Colors.black));
      }
    } else {
      showToast('网络连接异常',
          duration: const Duration(seconds: 2),
          position: ToastPosition.bottom,
          backgroundColor: Colors.black12,
          textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          textStyle: const TextStyle(color: Colors.black));
    }
    return response;
  }
}
