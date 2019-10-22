part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]);
}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final AuthUser user;

  LoggedIn(this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {

  @override
  List<Object> get props => [];
}
