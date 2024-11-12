// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Import your Blocs
import 'bloc/otp_verification/otp_verification_bloc.dart';
import 'bloc/phone_verification/phone_verification_bloc.dart';
import 'bloc/language_selection/language_bloc.dart';

// Import your Screens
import 'screens/landing.dart';
import 'screens/userAuth/languageSelection.dart';

// Import your Services
import 'services/api_services.dart';

// Import Language Events and States
import 'bloc/language_selection/language_event.dart';
import 'bloc/language_selection/language_state.dart';

// Define your color constants
const Color primaryColor = Color(0xff040403); // Medium green
const Color secondaryColor = Color(0xff5b7553); // Light yellow
const Color accentColor1 = Color(0xff919191); // Soft brown
const Color accentColor2 = Color(0xFFc3e8bd); // Medium purple
const Color neutralColor = Color(0xFFffffff); // White
const Color onPrimaryColor = Colors.white; // Example onPrimary color

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Instantiate ApiService with your backend base URL
  final ApiService apiService = ApiService(
    baseUrl: 'http://10.0.2.2:3000/api/farmers', // For Android Emulator
    // For iOS Simulator or Physical Device, replace with your machine's IP, e.g., 'http://192.168.1.100:3000/api/farmers'
  );

  runApp(MyApp(
    isFirstTime: isFirstTime,
    selectedLanguage: selectedLanguage,
    apiService: apiService,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String selectedLanguage;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.selectedLanguage,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide LanguageBloc
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc()..add(SelectLanguage(selectedLanguage)),
        ),
        // Provide PhoneVerificationBloc with ApiService
        BlocProvider<PhoneVerificationBloc>(
          create: (_) => PhoneVerificationBloc(apiService: apiService),
        ),
        // Provide OtpVerificationBloc with ApiService
        BlocProvider<OtpVerificationBloc>(
          create: (_) => OtpVerificationBloc(apiService: apiService),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          // Determine the locale based on the selected language
          Locale locale;
          if (state is LanguageSelected) {
            locale = Locale(state.selectedLanguage);
          } else {
            locale = const Locale('en', 'US'); // Default locale
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Green Camellia',
            locale: locale,
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('ta', 'IN'), // Tamil
              Locale('hi', 'IN'), // Hindi
              Locale('as', 'IN'), // Assamese
              Locale('te', 'IN'), // Telugu
              Locale('kn', 'IN'), // Kannada
              Locale('ml', 'IN'), // Malayalam
              Locale('pa', 'IN'), // Punjabi
            ],
            localizationsDelegates: [
              FlutterI18nDelegate(
                translationLoader: FileTranslationLoader(
                  useCountryCode: false,
                  fallbackFile: 'en',
                  basePath: 'assets/lang',
                ),
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: const ColorScheme.light().copyWith(
                primary: primaryColor,
                onPrimary: onPrimaryColor,
                secondary: secondaryColor,
                surface: neutralColor,
                error: Colors.red,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.white,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                // Define other text styles as needed
              ),
              hintColor: accentColor1,
              secondaryHeaderColor: accentColor2,
              scaffoldBackgroundColor: neutralColor,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: const TextStyle(color: primaryColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor, // Button text color
                  side: const BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            home: isFirstTime ? const Landing() : const LanguageSelection(),
          );
        },
      ),
    );
  }
}
