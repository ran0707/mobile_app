// lib/screens/userAuth/languageSelection.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp01/screens/dashboard/home.dart';
import '../../bloc/language_selection/language_bloc.dart';
import '../../bloc/language_selection/language_event.dart';
import '../../bloc/language_selection/language_state.dart';
import 'phoneVerify.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});

  Future<void> _selectLanguage(
      BuildContext context, String languageCode) async {
    context.read<LanguageBloc>().add(SelectLanguage(languageCode));

    // Navigate to Phone Verification Page after selecting language
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PhoneVerification(),
        //builder: (context) => const Home(locality: '',),
      ),
    );
  }

  // Define a list of languages
  final List<Map<String, String>> languages = const [
    {'name': 'English', 'code': 'en'},
    {'name': 'தமிழ்', 'code': 'ta'},
    {'name': 'हिंदी', 'code': 'hi'},
    {'name': 'অসমীয়া', 'code': 'as'},
    {'name': 'తెలుగు', 'code': 'te'},
    {'name': 'ಕನ್ನಡ', 'code': 'kn'},
    {'name': 'മലയാളം', 'code': 'ml'},
    {'name': 'ਪੰਜਾਬੀ', 'code': 'pa'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        String selectedLanguage;
        if (state is LanguageSelected) {
          selectedLanguage = state.selectedLanguage;
        } else if (state is LanguageInitial) {
          selectedLanguage = state.selectedLanguage;
        } else {
          selectedLanguage = 'en'; // Default to English
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              FlutterI18n.translate(context, 'language_selection_title'),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return _buildLanguageOption(
                context,
                languageName: language['name']!,
                languageCode: language['code']!,
                isSelected: selectedLanguage == language['code'],
              );
            },
          ),
        );
      },
    );
  }

  // Helper method to build each language option with border and tick
  Widget _buildLanguageOption(
      BuildContext context, {
        required String languageName,
        required String languageCode,
        required bool isSelected,
      }) {
    return GestureDetector(
      onTap: () => _selectLanguage(context, languageCode),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                languageName,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
