import 'package:bloc/bloc.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_event.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_state.dart';


class ContentItem {
  final String image;
  final String title;
  final String content;

  ContentItem(this.image, this.title, this.content);

}



class CultivationPageBloc extends Bloc<CultivationPageEvent, CultivationPageState>{

  CultivationPageBloc() : super(ContentLoading()){
    on<LoadContent>(_onLoadContent);
  }

  void _onLoadContent(LoadContent event, Emitter<CultivationPageState> emit){
    try{
      final items =[
        ContentItem('Images/TeaDisease.png', 'Tea Diseases ', 'Tea plant Disease\nAll about Tea Disease and Insects'),
        ContentItem('Images/TeaPesticides.png', 'Tea Pesticides ', 'Tea Plant Pesticides\nControl methods, Biological Control..'),
        ContentItem('Images/TeaCultivation.png', 'Tea Cultivation ', 'All about Tea\nHistory of Tea, cultivation methods'),
        ContentItem('Images/TeaRecipe.png', ' Tea Recipe ', 'Explore the Taste of Tea\nVariety of Tea Recipes '),
      ];
      emit(ContentLoaded(items));
    }catch(_){
      emit(ContentError());
    }
  }
}
