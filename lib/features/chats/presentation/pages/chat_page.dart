import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_state.dart';
import 'package:immobilier/features/chats/presentation/widgets/item_chat_custum.dart';
import 'package:immobilier/features/chats/presentation/widgets/loader.dart';

class MyChatPage extends StatefulWidget {
  final String userUidInfo;
  const MyChatPage({Key? key, required this.userUidInfo}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  void allUser() {
    BlocProvider.of<UserCubit>(context).getAllUser();
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUser();
    super.initState();
  }

  final List<UserEntity> allUserEntity = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
        if (userState is UserLoader) {
          print("----->je suis dans le UserLoader");
          return listUser(userState);
        }
        print("----->je suis dans le Circular");
        return const Center(
          child: CircularLoader(),
        );
      }),
    );
  }

  Widget listUser(UserLoader listUser) {
    return ListView.builder(
        itemCount: listUser.users.length,
        itemBuilder: (_, index) {
          if (listUser.users[index].uid == widget.userUidInfo) {
            return Container(); //on n'affiche tout sauf l'utilisateur courant
          }
          print("taille du tableau----->${listUser.users.length}");
          return ItemChatCustum(
              userUidInfo: widget.userUidInfo,
              otherUser: listUser.users[index]);
        });
  }
}
