// lib/bloc/language_selection/language_state.dart

import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  final String selectedLanguage;

  const LanguageState({required this.selectedLanguage});

  @override
  List<Object> get props => [selectedLanguage];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial({super.selectedLanguage = 'en'});
}

class LanguageSelected extends LanguageState {
  const LanguageSelected(String selectedLanguage)
      : super(selectedLanguage: selectedLanguage);
}
