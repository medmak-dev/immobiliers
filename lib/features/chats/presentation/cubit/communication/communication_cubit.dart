import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/usecases/add_to_my_chat_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_one_to_one_single_user_chat_chat_channel_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_text_message_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/send_text_message_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final GetTextMessageUsecase getTextMessageUsecase;
  final SendTextMessageUsecase sendTextMessageUsecase;
  final AddToMyChatUsecase addToMyChatUsecase;
  final GetOneToOneSingleUserChatChannelUsecase
      getOneToOneSingleUserChatChannelUsecase;
  CommunicationCubit(
      {required this.getOneToOneSingleUserChatChannelUsecase,
      required this.getTextMessageUsecase,
      required this.sendTextMessageUsecase,
      required this.addToMyChatUsecase})
      : super(CommunicationInitiale());

  Future<void> sendMessage(
      {required TextMessageEntity textMessageEntity}) async {
    try {
      final channelId = await getOneToOneSingleUserChatChannelUsecase.call(
          uid: textMessageEntity.senderUID,
          otherUid: textMessageEntity.recipientUID);

      //on enregistre les message
      final newMessage = TextMessageEntity(
          message: textMessageEntity.message,
          messageId: " ",
          recipientName: textMessageEntity.recipientName,
          recipientUID: textMessageEntity.recipientUID,
          senderName: textMessageEntity.senderName,
          senderUID: textMessageEntity.senderUID,
          messageType: "texte",
          time: Timestamp.now());
      await sendTextMessageUsecase.call(
          textMessageEntity: newMessage, channelId: channelId);

//on enregistre dans les chat
      final myNewChat = MyChatEntity(
        time: Timestamp.now(),
        senderName: textMessageEntity.senderName,
        senderUID: textMessageEntity.senderUID,
        recipientName: textMessageEntity.recipientName,
        recipientUID: textMessageEntity.recipientUID,
        channelId: channelId,
        recipientEmail: " ",
        profileUrl: " ",
        isRead: true,
        recentMessage: textMessageEntity.message,
      );
      await addToMyChatUsecase.call(myChatEntity: myNewChat);
    } on SocketException catch (_) {
      emit(CommunicationFaillure());
    } catch (_) {
      emit(CommunicationFaillure());
    }
  }

  Future<void> getMessage(
      {required String senderUID, required String recipientUID}) async {
    emit(CommunicationLoading());
    try {
      final channelId = await getOneToOneSingleUserChatChannelUsecase.call(
          uid: senderUID, otherUid: recipientUID);
      final messageStreamData =
          getTextMessageUsecase.call(channelId: channelId);
      await messageStreamData.then((value) {
        //on ecoute le flux et on renvoie les message recueilli dans ce flux et on re renvoi sou forme de liste de messsage dans la commuicationState
        value.listen((message) {
          emit(CommunicationLoader(message: message));
        });
      });
    } on SocketException catch (_) {
      emit(CommunicationFaillure());
    } catch (_) {
      emit(CommunicationFaillure());
    }
  }
}
