import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class GetTextMessageUsecase {
  final FirebaseRepository repository;
  GetTextMessageUsecase({required this.repository});

  Future<Stream<List<TextMessageEntity>>> call({required String channelId}) async{
    return repository.getMessage(channelId: channelId);
  }
}
