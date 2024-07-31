import 'package:equatable/equatable.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_bloc.dart';

abstract class CultivationPageState extends Equatable{

  @override
  List<Object> get props => [];
}

class ContentLoading extends CultivationPageState{}
class ContentLoaded extends CultivationPageState{
  final List<ContentItem> items;

  ContentLoaded(this.items);

  @override
  List<Object> get props =>[items];
}
class ContentError extends CultivationPageState{}