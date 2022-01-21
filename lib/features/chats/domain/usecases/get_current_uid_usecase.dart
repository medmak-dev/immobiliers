import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class GetCurrentUidUsecase {
  final FirebaseRepository repository;
  const GetCurrentUidUsecase({required this.repository});

  Future<String> call() async {
    return repository.getCurrentUID();
  }
}
