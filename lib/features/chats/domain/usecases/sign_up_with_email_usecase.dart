import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class SignUpWithEmailUsecase {
  final FirebaseRepository repository;
  SignUpWithEmailUsecase({required this.repository});

  Future<void> call({required UserEntity userEntity}) {
    return repository.signUpWithEmail(userEntity: userEntity);
  }
}
