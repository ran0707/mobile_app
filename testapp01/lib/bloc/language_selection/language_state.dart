import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}


class LanguageInitial extends LanguageState{}

class LanguageSelected extends LanguageState{

  final String selectedLanguage;

  const LanguageSelected(this.selectedLanguage);

  @override
  List<Object> get props =>[selectedLanguage];
}

