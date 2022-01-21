import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthAuthentificated extends AuthState {
  final String uid;
 const  AuthAuthentificated({required this.uid});
  @override
  List<Object?> get props => [];
}

class AuthUnAuthentificated extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
