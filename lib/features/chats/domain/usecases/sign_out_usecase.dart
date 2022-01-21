import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class SignOutUsecase{
  final FirebaseRepository repository;
  SignOutUsecase({required this.repository});

  Future<void> call() async{
    return await repository.signOut();
  }
}
