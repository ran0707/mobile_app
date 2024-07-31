import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';


class LanguageBloc extends Bloc<LanguageEvent, LanguageState>{

  LanguageBloc(): super(LanguageInitial()){
    on<SelectLanguage>(_onSelectLanguage);

  }


void _onSelectLanguage(SelectLanguage event, Emitter<LanguageState> emit){
    emit(LanguageSelected(event.language));
  }
}