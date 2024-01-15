// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../main.dart';
//
// Future<http.Response> safeApiCall(Uri url, BuildContext context) async {
//   final response = await http.get(url);
//
//   if (response.statusCode == 401) {
//     // If the server did return a 401 UNAUTHORIZED response,
//     // then we navigate to the login page
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => LoginPage()),
//           (Route<dynamic> route) => false,
//     );
//   }
//   return response;
// }
