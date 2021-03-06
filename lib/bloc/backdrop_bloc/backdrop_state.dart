part of 'backdrop_bloc.dart';

@immutable
abstract class BackdropState extends Equatable {
  BackdropState([List props = const []]);
}

class Ready extends BackdropState {
  final String route;
  final dynamic content;
  final dynamic subscription;
  final dynamic subscriptionArgs;
  final int subtype;

  Ready([this.route, this.content, this.subscription, this.subscriptionArgs, this.subtype]) : super([route,content,subscription,subscriptionArgs,subtype]);

  @override
  List<Object> get props => [route,content,subscription,subscriptionArgs,subtype];
}

class NotReady extends BackdropState {
  @override
  List<Object> get props => [];
}

class NotificationWaitingState extends BackdropState {
  final List<Event> waitingEvents;

  NotificationWaitingState(this.waitingEvents) : super(waitingEvents);

  @override
  List<Object> get props => [waitingEvents];
}








