import 'package:equatable/equatable.dart';
import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';

abstract class MyChatState extends Equatable {
  const MyChatState();
}

class MyChatStateInitiale extends MyChatState {
  @override
  List<Object?> get props => throw [];
}

class MyChatStateLoading extends MyChatState {
  @override
  List<Object?> get props => [];
}

class MyChatStateLoader extends MyChatState {
  final List<MyChatEntity> myChat;
  const MyChatStateLoader({required this.myChat});
  @override
  List<Object?> get props => [myChat];
}

class MyChatStateFaillure extends MyChatState {
  @override
  List<Object?> get props => [];
}
