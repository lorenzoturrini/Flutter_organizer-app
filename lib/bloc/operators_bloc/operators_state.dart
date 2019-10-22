part of 'operators_bloc.dart';

@immutable
abstract class OperatorsState extends Equatable {
  OperatorsState([List props = const []]);
}

class Filtered extends OperatorsState {
  final List<Account> operators;

  Filtered([this.operators]) : super([operators]);

  @override
  List<Object> get props => [operators];
}

class Loaded extends OperatorsState {
  @override
  List<Object> get props => [];
}

class NotLoaded extends OperatorsState {
  @override
  List<Object> get props => [];
}








