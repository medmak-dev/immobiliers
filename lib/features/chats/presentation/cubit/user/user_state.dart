import 'package:equatable/equatable.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitiale extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoader extends UserState {
 final  List<UserEntity> users;
 const  UserLoader({required this.users});
  @override
  List<Object?> get props => [users];
}

class UserFaillure extends UserState{
  @override
  List<Object?> get props => [];
}
