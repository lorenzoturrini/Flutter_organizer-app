part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]);
}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final AuthUser user;
  final bool isSupervisor;

  Authenticated([this.user,this.isSupervisor]) : super([user,isSupervisor]);

  @override
  List<Object> get props => [this.user,this.isSupervisor];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}