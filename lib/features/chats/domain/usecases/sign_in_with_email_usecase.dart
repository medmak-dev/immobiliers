import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class SignInWithEmailUsecase {
  final FirebaseRepository repository;
  SignInWithEmailUsecase({required this.repository});

  Future<void> call({required UserEntity userEntity}) async {
    return repository.signInWithEmail(userEntity: userEntity);
  }
}
