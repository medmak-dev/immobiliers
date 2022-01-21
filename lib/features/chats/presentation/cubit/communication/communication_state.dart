import 'package:equatable/equatable.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';

abstract class CommunicationState extends Equatable {
  const CommunicationState();
}

class CommunicationInitiale extends CommunicationState {
  @override
  List<Object?> get props => [];
}

class CommunicationLoading extends CommunicationState {
  @override
  List<Object?> get props => [];
}

class CommunicationLoader extends CommunicationState {
  final List<TextMessageEntity> message;
  const CommunicationLoader({required this.message});
  @override
  List<Object?> get props => [message];
}

class CommunicationFaillure extends CommunicationState {
  @override
  List<Object?> get props => [];
}
