// lib/services/api_services.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> registerUser({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
      }),
    );
    return response;
  }

  Future<http.Response> verifyOtp({
    required String phone,
    required String otpCode,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'otp_code': otpCode,
      }),
    );
    return response;
  }
}
