// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Send OTP
  Future<Map<String, dynamic>> sendOtp(String name, String phone) async {
    final url = Uri.parse('$baseUrl/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'phone': phone}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle server errors
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to send OTP.');
    }
  }

  // Verify OTP and Register User
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otpCode,
    required String address,
    required String city,
    required String state,
    required String country, required String name,
  }) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name':name,
        'phone': phone,
        'otp_code': otpCode,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle server errors
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to verify OTP.');
    }
  }
}
