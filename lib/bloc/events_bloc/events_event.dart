part of 'events_bloc.dart';

@immutable
abstract class EventsEvent extends Equatable {
  EventsEvent([List props = const []]);
}

class LoadEvents extends EventsEvent {
  final dynamic subscription;
  final dynamic args;

  LoadEvents(this.subscription, this.args) : super([subscription,args]);

  @override
  List<Object> get props => [subscription,args];
}

class FilterEventsByDay extends EventsEvent {
  final DateTime selectedDay;

  FilterEventsByDay(this.selectedDay) : super([selectedDay]);

  @override
  List<Object> get props => [selectedDay];
}

class FilterEventsByMonth extends EventsEvent {
  final DateTime selectedDay;

  FilterEventsByMonth(this.selectedDay) : super([selectedDay]);

  @override
  List<Object> get props => [selectedDay];
}

class FilterEventsByWaiting extends EventsEvent {
  @override
  List<Object> get props => [];
}

class AddEvent extends EventsEvent {
  final Event event;

  AddEvent(this.event) : super([event]);

  @override
  List<Object> get props => [event];
}

class UpdateEvent extends EventsEvent {
  final Event event;

  UpdateEvent(this.event) : super([event]);

  @override
  List<Object> get props => [event];
}

class DeleteEvent extends EventsEvent {
  final Event event;

  DeleteEvent(this.event) : super([event]);

  @override
  List<Object> get props => [event];
}

class EventsUpdated extends EventsEvent {
  final List<Event> events;

  EventsUpdated(this.events);

  @override
  List<Object> get props => [events];
}

class Done extends EventsEvent {
  final List<Event> events;
  final DateTime selectedDay;

  Done(this.events, this.selectedDay);

  @override
  List<Object> get props => [events,selectedDay];
}