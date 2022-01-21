import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource{
     //Authentification
  Future<void> signInWithEmail({required UserEntity userEntity});
  Future<void> signUpWithEmail({required UserEntity userEntity});
  Future<void> signOut();
  Future<bool> isSignIn();

//ajout dans firebase
  Future<void> addToMyChat({required MyChatEntity myChatEntity});
  Future<void> sendTextMessage({required TextMessageEntity textMessageEntity,required String channelId});
  Future<void> createOneToOneUserChatChannel({required String uid, required String otherUid}); //creation d'un identifient unique constituer des deux identifient
  Future<String> getOneToOneSingleUserChatChannel({required String uid, required String otherUid}); //on recupere les conversation

  //recuperation
  //Flux de donée
Future<Stream<List<UserEntity>>> getAllUser();
  Future<Stream<List<TextMessageEntity>>> getMessage({required String channelId}); //on recupere la liste de message entre deux utilisateur a partie de l'identifient des deux UID unique créé dans firebase
  Stream<List<MyChatEntity>> getMyChat({required String uid}); //on recupere la liste de mes conversation dans firebase a partie de mon UID(le UID du current user)
  //
  Future<void> getCreateCurrentUser({required UserEntity user});
  Future<String> getCurrentUID();

 }