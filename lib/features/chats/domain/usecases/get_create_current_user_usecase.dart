import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';


class GetCreateCurrentUserUsecase {
  FirebaseRepository repository;
  GetCreateCurrentUserUsecase({required this.repository});

  Future<void> call({required UserEntity user}) async {
    return repository.getCreateCurrentUser(user: user);
  }
}
