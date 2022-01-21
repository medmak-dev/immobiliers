import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyChatEntity extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String channelId;
  final String recipientUID;
  final String profileUrl;
  final String recipientEmail;
  final String recentMessage;
  final bool isRead;
  final Timestamp time;

  const MyChatEntity({
  required  this.senderName,
   required this.senderUID,
   required this.recipientName,
   required this.recipientUID,
   required this.channelId,
   required this.recipientEmail,
   required this.profileUrl,
   required this.isRead,
   required this.recentMessage,
   required this.time,
  });

  @override
  List<Object?> get props => [
        senderName,
        senderUID,
        recipientName,
        recipientUID,
        channelId,
        recipientEmail,
        profileUrl,
        isRead,
        recentMessage,
        time,
      ];
}
