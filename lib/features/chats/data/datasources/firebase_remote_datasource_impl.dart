import 'package:immobilier/features/chats/data/datasources/firebase_remote_datasource.dart';
import 'package:immobilier/features/chats/data/models/my_chat_model.dart';
import 'package:immobilier/features/chats/data/models/text_message_model.dart';
import 'package:immobilier/features/chats/data/models/user_model.dart';
import 'package:immobilier/features/chats/domain/entities/text_message_entity.dart';
import 'package:immobilier/features/chats/domain/entities/my_chat_entity.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<void> signOut() async {
    auth.signOut();
  }

  @override
  Future<void> signUpWithEmail({required UserEntity userEntity}) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: userEntity.email, password: userEntity.password);
      print("-----> the response $result");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> isSignIn() async {
    return auth.currentUser!.uid.isNotEmpty;
  }

  @override
  Future<String> getCurrentUID() async {
    return auth.currentUser!.uid;
  }

  @override
  Future<void> getCreateCurrentUser({required UserEntity user}) async {
    final userCollection = firestore.collection("users");
    final uid = await getCurrentUID();
    userCollection.doc(uid).get().then((userDoc) {
      final users = UserModel(
              email: user.email,
              name: user.name,
              isOnline: user.isOnline,
              password: user.password,
              phoneNumber: user.phoneNumber,
              postName: user.postName,
              profilUrl: user.profilUrl,
              uid: uid,
              timestamp: Timestamp.now())
          .toDocument();
      if (!userDoc.exists) {
        //si l'utilisateur existe pas on le crée
        userCollection.doc(uid).set(users);
      } else {
        //sinon on le mets a jours
        userCollection.doc(uid).update(users);
      }
    });
  }

  @override
  Future<void> signInWithEmail({required UserEntity userEntity}) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: userEntity.email, password: userEntity.password);
      print("response $response");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> addToMyChat({required MyChatEntity myChatEntity}) async {
    final mychatRef = firestore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat");

    final otherChatRef = firestore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection("myChat");
    //ici on enregistre enfait les conversation sur les message envoyer dans les deux partenaire: si j'envoie un message a toto, on retrouver a la fois che mois et che toto les meme message
    final myNewChat = MyChatModel(
            // lorsque c'est mois qui envoie le message
            senderName: myChatEntity.senderName,
            senderUID: myChatEntity.senderUID,
            recipientName: myChatEntity.recipientName,
            recipientUID: myChatEntity.recipientUID,
            channelId: myChatEntity.channelId,
            recipientEmail: myChatEntity.recipientEmail,
            profileUrl: myChatEntity.profileUrl,
            isRead: myChatEntity.isRead,
            recentMessage: myChatEntity.recentMessage,
            time: myChatEntity.time)
        .toDocument();

    final otherNewChat = MyChatModel(
            senderName: myChatEntity
                .recipientName, // lorsque c'est le partenaire qui envoie le message
            senderUID: myChatEntity.recipientUID,
            recipientName: myChatEntity.senderName,
            recipientUID: myChatEntity.senderUID,
            channelId: myChatEntity.channelId,
            recipientEmail: myChatEntity.recipientEmail,
            profileUrl: myChatEntity.profileUrl,
            isRead: myChatEntity.isRead,
            recentMessage: myChatEntity.recentMessage,
            time: myChatEntity.time)
        .toDocument();

    mychatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        //si le document n'exixte pas on le crée
        //create
        mychatRef.doc(myChatEntity.recipientUID).set(
            myNewChat); //si c'est le partenaire qui recoit le message venant de moi
        otherChatRef.doc(myChatEntity.senderUID).set(
            otherNewChat); //si c'est moi  qui recoit le message venant du partenaire
        return;
      } else {
        //sinon on le met a jour
        //update
        mychatRef.doc(myChatEntity.recipientUID).update(myNewChat);
        otherChatRef.doc(myChatEntity.recipientUID).update(otherNewChat);
        return;
      }
    });
  }

  @override
  Future<Stream<List<UserEntity>>> getAllUser() async {
    final collectionref = firestore.collection("users").orderBy("name");
    return collectionref.snapshots().map((querrySnapshot) {
      return querrySnapshot.docs
          .map((querryDocSnapshot) => UserModel.fromSnapshot(querryDocSnapshot))
          .toList();
    });
  }

  @override
  Future<void> createOneToOneUserChatChannel(
      {required String uid, required String otherUid}) async {
    final userCollectionRef = firestore.collection("users");
    final oneToOneChatChannelRef = firestore.collection("myChatChannel");

    userCollectionRef
        .doc(uid)
        .collection("engagedChatChannel")
        .doc(otherUid)
        .get()
        .then((chatChannelDoc) {
      if (chatChannelDoc.exists) {
        return;
      }
      //if not exist
      final _chatChannelId = oneToOneChatChannelRef.doc().id;
      var channelMap = {
        "channelId": _chatChannelId,
        "channelType": "oneToOneChat",
      };
      oneToOneChatChannelRef.doc(_chatChannelId).set(
          channelMap); //on cree la liste des message et lon y ajoute tout les identifient unique de nos message
      //current user
      //pour crée un lien entre la liste des chat et des message
      userCollectionRef
          .doc(uid)
          .collection("engagedChatChannel")
          .doc(otherUid)
          .set(channelMap);
//lorsque on voudra les conversation correspondant a une discussion, on recuperera engageChatchannel>ortheruid>oneToOneChat et on parcourera la collection engageChannel avec cette identifient pour recuperé ses messag
      //otherUser
      userCollectionRef
          .doc(otherUid)
          .collection("engagetChatChannel")
          .doc(uid)
          .set(channelMap);
      return;
    });
  }

  @override
  Future<Stream<List<TextMessageEntity>>> getMessage(
      {required String channelId}) async {
    final messageRef = firestore
        .collection("myChatChannel")
        .doc(channelId)
        .collection("messages");
    return messageRef.orderBy('time').snapshots().map((querySnapshot) =>
        querySnapshot.docs
            .map((messageDoc) => TextMessageModel.fromSnapshot(messageDoc))
            .toList());
  }

  @override
  Stream<List<MyChatEntity>> getMyChat({required String uid}) {
    //uid c'est  le current uid
    final myChatRef =
        firestore.collection("users").doc(uid).collection("myChat");
    return myChatRef
        .orderBy("time", descending: true)
        .snapshots()
        .map((querryMessage) {
      return querryMessage.docs
          .map((messageSnap) => MyChatModel.fromSnapshot(messageSnap))
          .toList();
    });
  }

  @override
  Future<String> getOneToOneSingleUserChatChannel(
      {required String uid, required String otherUid}) async {
    final userCollection = firestore.collection("users");
    return userCollection
        .doc(uid)
        .collection("engagedChatChannel")
        .doc(otherUid)
        .get()
        .then((engagedChatChannel) {
      if (engagedChatChannel.exists) {
        return engagedChatChannel.data()!['channelId'];
      }
      // ignore: null_argument_to_non_null_type
      return Future.value(null);
    });
  }

  @override
  Future<void> sendTextMessage(
      {required TextMessageEntity textMessageEntity,
      required String channelId}) async {
    final messageRef = firestore
        .collection("myChatChannel")
        .doc(channelId)
        .collection("messages");
    final messageId = messageRef.doc().id;
    messageRef.doc(messageId).get().then((value) {
      final newMessage = TextMessageModel(
              senderUID: textMessageEntity.senderUID,
              senderName: textMessageEntity.senderName,
              recipientUID: textMessageEntity.recipientUID,
              recipientName: textMessageEntity.recipientName,
              messageId: messageId,
              message: textMessageEntity.message,
              time: textMessageEntity.time,
              messageType: textMessageEntity.messageType)
          .toDocument();
      if (value.exists) {
        messageRef.doc(messageId).update(newMessage);
      } else {
        messageRef.doc(messageId).set(newMessage);
      }
    });
  }
}
