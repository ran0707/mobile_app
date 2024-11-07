// test/main_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testapp01/screens/dashboard/home.dart';
import 'package:testapp01/screens/landing.dart';
import 'package:testapp01/main.dart';
import 'package:testapp01/screens/userAuth/phoneVerify.dart';

import 'package:testapp01/services/api_services.dart';

// Mock ApiService for testing
class MockApiService extends ApiService {
  MockApiService()
      : super(
    baseUrl: 'https://mock-backend.com',
    textlocalApiKey: 'mock_api_key',
  );

  @override
  Future<Map<String, dynamic>> requestOtp({
    required String phone,
    required String name,
    required String streetCity,
    required String adminLocality,
    required String country,
    required String postalCode,
  }) async {
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return {'success': true};
  }

  @override
  Future<bool> sendOtpTextlocal({
    required String phoneNumber,
    required String message,
  }) async {
    return true;
  }
}

void main() {
  final mockApiService = MockApiService();

  testWidgets('Landing page is shown when app is opened for the first time',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MyApp(
            isFirstTime: true,
            selectedLanguage: 'en',
            apiService: mockApiService,
          ),
        );

        // Verify that Landing page is shown
        expect(find.byType(Landing), findsOneWidget);
        expect(find.text('Green Gaurd'), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
      });

  testWidgets('Home page is shown when token is valid',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MyApp(
            isFirstTime: false,
            selectedLanguage: 'en',
            apiService: mockApiService,
          ),
        );

        // Verify that Home page is shown
        expect(find.byType(Home), findsOneWidget);
      });

  testWidgets(
      'PhoneVerification page is shown when there is no valid token and not the first time',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MyApp(
            isFirstTime: false,
            selectedLanguage: 'en',
            apiService: mockApiService,
          ),
        );

        // Verify that PhoneVerification page is shown
        expect(find.byType(PhoneVerification), findsOneWidget);
      });
}
