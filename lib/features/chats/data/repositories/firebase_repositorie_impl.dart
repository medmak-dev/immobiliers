import 'package:immobilier/features/chats/data/datasources/firebase_remote_datasource.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  FirebaseRemoteDataSource firebaseRemoteDataSource;
  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<void> addToMyChat({required MyChatEntity myChatEntity}) {
    return firebaseRemoteDataSource.addToMyChat(myChatEntity: myChatEntity);
  }

  @override
  Future<void> createOneToOneUserChatChannel(
      {required String uid, required String otherUid}) {
    return firebaseRemoteDataSource.createOneToOneUserChatChannel(
        uid: uid, otherUid: otherUid);
  }

  @override
  Future<Stream<List<UserEntity>>> getAllUser() async =>
      firebaseRemoteDataSource.getAllUser();

  @override
  Future<void> getCreateCurrentUser({required UserEntity user}) {
    return firebaseRemoteDataSource.getCreateCurrentUser(user: user);
  }

  @override
  Future<String> getCurrentUID() {
    return firebaseRemoteDataSource.getCurrentUID();
  }

  @override
  Future<Stream<List<TextMessageEntity>>> getMessage(
      {required String channelId}) {
    return firebaseRemoteDataSource.getMessage(channelId: channelId);
  }

  @override
  Stream<List<MyChatEntity>> getMyChat({required String uid}) {
    return firebaseRemoteDataSource.getMyChat(uid: uid);
  }

  @override
  Future<String> getOneToOneSingleUserChatChannel(
      {required String uid, required String otherUid}) {
    return firebaseRemoteDataSource.getOneToOneSingleUserChatChannel(
        uid: uid, otherUid: otherUid);
  }

  @override
  Future<bool> isSignIn() {
    return firebaseRemoteDataSource.isSignIn();
  }

  @override
  Future<void> sendTextMessage(
      {required TextMessageEntity textMessageEntity,
      required String channelId}) {
    return firebaseRemoteDataSource.sendTextMessage(
        textMessageEntity: textMessageEntity, channelId: channelId);
  }

  @override
  Future<void> signInWithEmail({required UserEntity userEntity}) {
    return firebaseRemoteDataSource.signInWithEmail(userEntity: userEntity);
  }

  @override
  Future<void> signOut() {
    return firebaseRemoteDataSource.signOut();
  }

  @override
  Future<void> signUpWithEmail({required UserEntity userEntity}) {
    return firebaseRemoteDataSource.signUpWithEmail(userEntity: userEntity);
  }
}
