
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageInitial()) {
    on<SelectLanguage>(_onSelectLanguage);
    on<LoadLanguage>(_onLoadLanguage);
  }

  Future<void> _onSelectLanguage(SelectLanguage event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', event.languageCode);
    emit(LanguageSelected(event.languageCode));
  }

  Future<void> _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    emit(LanguageSelected(selectedLanguage));
  }
}