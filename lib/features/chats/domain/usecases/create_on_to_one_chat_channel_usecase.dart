import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';
//dans ce usecase nous passon les uid des differentt utilisateur et dans la BD on créé un identifient unique pour la conversation

class CreateOneToOneChatChannelUsecase {
  final FirebaseRepository repository;
  const CreateOneToOneChatChannelUsecase({required this.repository});

  Future<void> call(String uid, String otherUid) async {
    repository.createOneToOneUserChatChannel(uid: uid,otherUid: otherUid);
  }

}
