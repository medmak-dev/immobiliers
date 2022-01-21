import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  const TextMessageModel({
    required String senderUID,
    required String senderName,
    required String recipientUID,
    required String recipientName,
    required String messageId,
    required String message,
    required Timestamp time,
    required String messageType,
  }) : super(
          senderName: senderName,
          senderUID: senderUID,
          recipientName: recipientName,
          recipientUID: recipientUID,
          message: message,
          messageId: messageId,
          messageType: messageType,
          time: time,
        );

  factory TextMessageModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return TextMessageModel(
        senderUID: snapshot["senderUID"],
        senderName: snapshot["senderName"],
        recipientUID: snapshot["recipientUID"],
        recipientName: snapshot["recipientName"],
        messageId: snapshot[" messageId"],
        message: snapshot["message"],
        time: snapshot["time"],
        messageType: snapshot["messageType"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName":senderName,
      "senderUID":senderUID,
      "recipientUid":recipientUID,
      "recipientName":recipientName,
      "messageId":messageId,
      "message":message,
      "time":time,
      "messageType":messageType,

    };
  }
}
