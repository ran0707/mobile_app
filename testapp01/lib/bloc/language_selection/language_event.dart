import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable{
  const LanguageEvent();

  @override
  List<Object> get props =>[];

}

class SelectLanguage extends LanguageEvent{
  final String language;

  const SelectLanguage(this.language);


  @override
  List<Object> get props =>[language];
}