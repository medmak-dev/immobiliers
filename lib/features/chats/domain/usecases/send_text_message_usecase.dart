import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class SendTextMessageUsecase {
  final FirebaseRepository repository;
  SendTextMessageUsecase({required this.repository});

  Future<void> call({required TextMessageEntity textMessageEntity,required String channelId}) async {
    return repository.sendTextMessage(textMessageEntity: textMessageEntity,channelId: channelId);
  }

}
