import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/usecases/create_on_to_one_chat_channel_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_all_user_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetAllUserUsecase getAllUserUsecase;
  final CreateOneToOneChatChannelUsecase createOneToOneChatChannelUsecase;
  UserCubit(
      {required this.getAllUserUsecase,
      required this.createOneToOneChatChannelUsecase})
      : super(UserInitiale());

  Future<void> getAllUser() async {
    UserLoading();
    try {
      final userStreamData = getAllUserUsecase.call();
      userStreamData.then((value) {
        value.listen((users) {
          emit(UserLoader(users: users));
        });
      });
    } on SocketException catch (_) {
      emit(UserFaillure());
    } catch (_) {
      emit(UserFaillure());
    }
  }

  Future<void> createChatChannel(
      {required String uid, required String otherUid}) async {
    try {
      await createOneToOneChatChannelUsecase.call(uid, otherUid);
    } on SocketException catch (_) {
      emit(UserFaillure());
    }catch (_) {
      emit(UserFaillure());
    }
  }
}
