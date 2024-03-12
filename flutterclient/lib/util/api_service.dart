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

  ApiService({this.baseUrl = 'http://192.168.168.15:8080'});

  Future<void> setToken(String accessToken, String refreshToken, String uid) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
    await storage.write(key: 'uid', value: uid);
  }

  Future<String?> getUid() async {
    try {
      String? uid = await storage.read(key: 'uid');
      print("Retrieved uid: $uid"); // 调试信息
      return uid ?? '';
    } catch (e) {
      print("Error getting uid: $e"); // 错误处理
      return '';
    }
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

  Future<bool> refreshToken() async {
    String? refreshToken = await storage.read(key: 'refresh_token');
    print("refreshToken:$refreshToken");
    if (refreshToken == null) {
      return false;
    }
    Map<String, String?> body = {"refresh-token": refreshToken};
    var response = await ApiService().post("/token/refresh", body);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['data']);
      // 存储token
      await setToken(result['data']['access-token'], result['data']['refresh-token'], result['data']['userId']);
      return true;
    } else {
      var statusCode = response.statusCode;
      print("refreshToken：=======$statusCode");
    }
    return false;
  }

  Future<void> clearToken() async {
    await storage.deleteAll();
  }

  Future<http.Response> get(String endpoint,
      {Map<String, dynamic>? params}) async {
    var token = await getToken();
    var headers = {
      'Authorization': 'Bearer $token',
    };
    // 构建带参数的 URL
    var uri = Uri.parse('$baseUrl$endpoint');
    // 如果传递了参数，则将参数添加到 URL 中
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(queryParameters: params);
    }
    final response = await http
        .get(uri, headers: headers)
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response, endpoint,
        headers: headers, data: params, method: 'GET');
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    var token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response, endpoint,
        headers: headers, data: data, method: 'POST');
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    var token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    )
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response, endpoint,
        headers: headers, data: data, method: 'PUT');
  }

  Future<http.Response> delete(String endpoint, dynamic data) async {
    var token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    )
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response(json.encode({'code': 408, 'msg': 'TIMEOUT'}), 408);
    });

    return _handleResponse(response, endpoint,
        headers: headers, data: data, method: 'DELETE');
  }

  Future<http.Response> _handleResponse(http.Response response, String endpoint,
      {Map<String, String>? headers,
      dynamic data,
      String method = 'GET'}) async {
    if (response.statusCode == 401) {
      bool refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        _clearToken();
        navigatorKey.currentState?.pushReplacementNamed('/login');
      } else {
        return await _retry(endpoint,
            headers: headers, data: data, method: method);
      }
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

  Future<http.Response> _retry(String endpoint,
      {Map<String, String>? headers,
      dynamic data,
      String method = 'GET'}) async {
    // 重新获取token
    var token = await getToken();
    // 更新请求头
    Map<String, String> updatedHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (headers != null) {
      updatedHeaders.addAll(headers);
    }

    // 根据请求方法发送请求
    Uri uri = Uri.parse('$baseUrl$endpoint');
    http.Response response;
    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(uri,
            headers: updatedHeaders, body: json.encode(data));
        break;
      case 'PUT':
        response = await http.put(uri,
            headers: updatedHeaders, body: json.encode(data));
        break;
      case 'DELETE':
        response = await http.delete(uri,
            headers: updatedHeaders, body: json.encode(data));
        break;
      default: // GET
        uri = uri.replace(queryParameters: data); // 假设data是一个包含查询参数的Map
        response = await http.get(uri, headers: updatedHeaders);
    }
    return response; // 返回重试后的响应
  }

  bool isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);

    if (!payloadMap.containsKey('exp')) {
      throw Exception('Invalid token: no expiry information');
    }

    final currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiryTimeInSeconds = payloadMap['exp'];

    return currentTimeInSeconds >= expiryTimeInSeconds;
  }
}
