part of 'operators_bloc.dart';

@immutable
abstract class OperatorsEvent extends Equatable {
  OperatorsEvent([List props = const []]);
}

class LoadOperators extends OperatorsEvent {
  final dynamic subscription;

  LoadOperators (this.subscription) : super([subscription]);

  @override
  List<Object> get props => [subscription];
}

class ApplyOperatorFilters extends OperatorsEvent {
  final String stringFilter;
  final DateTime dateFilter;

  ApplyOperatorFilters(this.stringFilter, this.dateFilter) : super([stringFilter, dateFilter]);

  @override
  List<Object> get props => [stringFilter, dateFilter];
}

class ApplyOperatorFilterString extends OperatorsEvent {
  final String stringFilter;

  ApplyOperatorFilterString(this.stringFilter) : super([stringFilter]);

  @override
  List<Object> get props => [stringFilter];
}

class ApplyOperatorFilterDate extends OperatorsEvent {
  final DateTime dateFilter;

  ApplyOperatorFilterDate(this.dateFilter) : super([dateFilter]);

  @override
  List<Object> get props => [];
}

class AddOperator extends OperatorsEvent {
  final Account user;

  AddOperator (this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class UpdateOperator extends OperatorsEvent {
  final Account user;

  UpdateOperator (this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class DeleteOperator extends OperatorsEvent {
  final Account user;

  DeleteOperator (this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class EventsUpdated extends OperatorsEvent {
  final List<Event> events;

  EventsUpdated(this.events);

  @override
  List<Object> get props => [events];
}

class Dones extends OperatorsEvent {
  final List<Account> operators;

  Dones(this.operators);

  @override
  List<Object> get props => [operators];
}