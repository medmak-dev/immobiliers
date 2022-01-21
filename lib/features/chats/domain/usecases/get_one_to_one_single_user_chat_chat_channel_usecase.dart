//ici on recupere l'identifient unique crée  a partie des deux UID des utilisateur
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class GetOneToOneSingleUserChatChannelUsecase {
  final FirebaseRepository repository;

  const GetOneToOneSingleUserChatChannelUsecase({required this.repository});

  Future<String> call({required String uid, required String otherUid}) async {
    return repository.getOneToOneSingleUserChatChannel(
        uid: uid, otherUid: otherUid);
  }
}
