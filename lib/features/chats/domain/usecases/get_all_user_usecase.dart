import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class GetAllUserUsecase {
  final FirebaseRepository repository;
  const GetAllUserUsecase({required this.repository});

  Future<Stream<List<UserEntity>>> call() async {
    return repository.getAllUser();
  }

}
