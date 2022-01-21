import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class AddToMyChatUsecase  {
  
 final FirebaseRepository repository;
  const AddToMyChatUsecase({required this.repository});

  Future<void> call({required MyChatEntity myChatEntity}) {
    return repository.addToMyChat(myChatEntity: myChatEntity);
  }

 
}
