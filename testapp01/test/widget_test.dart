import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testapp01/screens/dashboard/home.dart';
import 'package:testapp01/screens/landing.dart';
import 'package:testapp01/main.dart';
import 'package:testapp01/screens/userAuth/phoneVerify.dart';

void main() {
  testWidgets('Landing page is shown when app is opened for the first time', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isFirstTime: true,));

    // Verify that LandingPage is shown
    expect(find.byType(Landing), findsOneWidget);
    expect(find.text('Green Gaurd'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Home page is shown when token is valid', (WidgetTester tester) async {
    String validToken = 'your-valid-jwt-token'; // replace with an actual valid token if needed
    await tester.pumpWidget(MyApp(isFirstTime: false,  ));

    // Verify that Home page is shown
    expect(find.byType(Home), findsOneWidget);
  });

  testWidgets('PhoneVerification page is shown when there is no valid token and not the first time', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isFirstTime: false,  ));

    // Verify that PhoneVerification page is shown
    expect(find.byType(PhoneVerification), findsOneWidget);
  });
}
