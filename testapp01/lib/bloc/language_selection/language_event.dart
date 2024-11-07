
import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class SelectLanguage extends LanguageEvent {
  final String languageCode;

  const SelectLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LoadLanguage extends LanguageEvent {}