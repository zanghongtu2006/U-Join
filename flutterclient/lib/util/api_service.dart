import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class ApiService {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiService({this.baseUrl = 'http://192.168.168.10:8080'});

  Future<void> setToken(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token') ?? '';
  }

  Future<void> _clearToken() async {
    await storage.deleteAll();
  }

  Future<http.Response> get(String endpoint) async {
    var token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    var token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    var token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  Future<http.Response> delete(String endpoint, dynamic data) async {
    var token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      _clearToken();
      // 这里需要添加跳转到登录界面的代码
      navigatorKey.currentState?.pushReplacementNamed('/login');
    }
    return response;
  }
}
