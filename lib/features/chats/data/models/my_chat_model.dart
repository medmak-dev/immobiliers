import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyChatModel extends MyChatEntity {
  const MyChatModel({
    required final String senderName,
    required String senderUID,
    required String recipientName,
    required String recipientUID,
    required String channelId,
    required String recipientEmail,
    required String profileUrl,
    required bool isRead,
    required String recentMessage,
    required Timestamp time,
  }) : super(
          senderName: senderName,
          senderUID: senderUID,
          recipientEmail: recipientEmail,
          recipientName: recipientName,
          recipientUID: recipientUID,
          channelId: channelId,
          profileUrl: profileUrl,
          isRead: isRead,
          recentMessage: recentMessage,
          time: time,
          
        );

  factory MyChatModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return MyChatModel(
        senderName: snapshot["senderName"],
        senderUID: snapshot["senderUID"],
        recipientName: snapshot["recipientName"],
        recipientUID: snapshot["recipientUID"],
        channelId: snapshot["channelId"],
        recipientEmail: snapshot["recipientEmail"],
        profileUrl: snapshot["profileUrl"],
        isRead: snapshot["isRead"],
        recentMessage: snapshot["recentMessage"],
        time: snapshot["time"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "senderUID": senderUID,
      "recipientName":recipientName,
      "recipientUID":recipientUID,
      "channelId":channelId,
      "recipientEmail":recipientEmail,
      "profileUrl":profileUrl,
      "isRead":isRead,
      "recentMessage":recentMessage,
      "time":time,
    };
  }
}
