import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class GetMyChatUsecase {
  final FirebaseRepository repository;
  const GetMyChatUsecase({required this.repository});

  Future<Stream<List<MyChatEntity>>> call({required String uid}) async {
    return repository.getMyChat(uid:uid);
  }
}
