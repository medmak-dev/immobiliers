import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessageEntity extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String recipientUID;
  final String messageType;
  final String message;
  final String messageId;
  final Timestamp time;

  const TextMessageEntity(
      {required this.message,
      required this.messageId,
      required this.recipientName,
      required this.recipientUID,
      required this.senderName,
      required this.senderUID,
      required this.messageType,
      required this.time});
      
  @override
  List<Object?> get props => [
        senderName,
        senderUID,
        recipientName,
        recipientUID,
        message,
        messageType,
        messageId,
        time
      ];
}
