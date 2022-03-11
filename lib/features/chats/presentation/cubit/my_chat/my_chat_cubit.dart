import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/usecases/get_current_uid_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_my_chat_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/my_chat/my_chat_state.dart';

class MyChatCubit extends Cubit<MyChatState> {
  final GetMyChatUsecase getMyChatUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  MyChatCubit(
      {required this.getMyChatUsecase, required this.getCurrentUidUsecase})
      : super(MyChatStateInitiale());

  Future<void> getMyChat({required String uid}) async {
    try {
      final myChatStreamData = getMyChatUsecase.call(uid: uid);
      await myChatStreamData.then((value) {
        value.listen((myChat) {
          emit(MyChatStateLoader(myChat: myChat));
        });
      });
    } on SocketException catch (_) {
      emit(MyChatStateFaillure());
    } catch (_) {
      emit(MyChatStateFaillure());
    }
  }
}
