import 'package:equatable/equatable.dart';

abstract class CultivationPageEvent extends Equatable{

  @override
  List<Object> get props => [];
}

class LoadContent extends CultivationPageEvent {}