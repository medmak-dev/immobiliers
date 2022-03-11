import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authentificated extends AuthState {
  final String uid;
  const Authentificated({required this.uid});
  @override
  List<Object?> get props => [];
}

class UnAuthentificated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSucces extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
