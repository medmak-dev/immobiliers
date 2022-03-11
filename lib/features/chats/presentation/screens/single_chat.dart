import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/data/models/text_message_model.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_state.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';

class SingleChatPage extends StatefulWidget {
  final String userSenderUid;
  final UserEntity userRecipient;

  const SingleChatPage({
    Key? key,
    required this.userRecipient,
    required this.userSenderUid,
  }) : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<CommunicationCubit>(context).getMessage(
        senderUID: widget.userSenderUid,
        recipientUID: widget.userRecipient.uid);
    _textMessageController;
    _scrollController;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController;
    _textMessageController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: TextCustum(
          "${widget.userRecipient.postName} ${widget.userRecipient.name}",
          color: Colors.black,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(
                color: Colors.black54, shape: BoxShape.circle),
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profil.png"),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: BlocBuilder<CommunicationCubit, CommunicationState>(
          builder: (_, communicationState) {
        if (communicationState is CommunicationLoader) {
          return _bodyWidget(communicationState);
        }
        return Container();
      }),
    );
  }

  Widget _bodyWidget(CommunicationLoader communicationState) {
    return Column(
      children: [
        ListView.builder(
          itemCount: communicationState.message.length,
          itemBuilder: (context, index) {
            final messages = communicationState.message[index].message;
            return ListTile(title: Text(messages));
          },
        ),
      ],
    );
  }

  Widget _messageListWidget(CommunicationLoader message) {
    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
      );
    });
    return Expanded(
        child: ListView.builder(
            itemCount: message.message.length,
            itemBuilder: (context, index) {
              final messages = message.message[index];
              if (messages.senderUID == widget.userSenderUid) {
                return Container();
              } else {
                return Container();
              }
            }));
  }

  Widget messageLayout() {
    return Container();
  }

  Widget _sendMessageTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: Offset(0.0, 0.50),
                        spreadRadius: 1,
                        blurRadius: 1),
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 60,
                      ),
                      child: Scrollbar(
                        child: TextField(
                          maxLines: null,
                          style: TextStyle(fontSize: 14),
                          controller: _textMessageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.link),
                      SizedBox(
                        width: 10,
                      ),
                      _textMessageController.text.isEmpty
                          ? Icon(Icons.camera_alt)
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              if (_textMessageController.text.isNotEmpty) {
                _sendTextMessage(_textMessageController.text);
              }
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _sendTextMessage(String textMessage) {
    if (textMessage.isNotEmpty) {
      final textModel = TextMessageEntity(
          message: textMessage,
          messageId: " ",
          recipientName: widget.userRecipient.name,
          recipientUID: widget.userRecipient.uid,
          senderName: "",
          senderUID: "",
          messageType: "",
          time: Timestamp.now());

      BlocProvider.of<CommunicationCubit>(context)
          .sendMessage(textMessageEntity: textModel);
    }
  }
}
