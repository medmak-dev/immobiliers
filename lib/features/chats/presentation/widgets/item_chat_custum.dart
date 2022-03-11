import 'package:flutter/material.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/screens/single_chat.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';
import 'package:intl/intl.dart';

class ItemChatCustum extends StatelessWidget {
  final UserEntity otherUser;
  final String userUidInfo;
  const ItemChatCustum(
      {Key? key, required this.otherUser, required this.userUidInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SingleChatPage(
                    userRecipient: otherUser,
                    userSenderUid: userUidInfo,
                  );
                }));
              },
              child: Card(
                elevation: 1,
                child: Container(
                    height: 70,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1.5),
                          decoration: const BoxDecoration(
                              color: Colors.black54, shape: BoxShape.circle),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/profil.png"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              //  color: Colors.green,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustum(
                                        "${otherUser.postName} ${otherUser.name} ",
                                        color: Colors.black,
                                        size: 19,
                                      ),
                                      const Spacer(),
                                      TextCustum(
                                        "${DateFormat.yMMMd().format(otherUser.time.toDate())}  ",
                                        color: Colors.black54,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  TextCustum(
                                    "last message ",
                                    color: Colors.black38,
                                    size: 15,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
              )),
        ),
      ],
    );
  }
}
