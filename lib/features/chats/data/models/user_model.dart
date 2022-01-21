import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required String email,
      required String name,
      required bool isOnline,
      required String password,
      required String phoneNumber,
      required String postName,
      required String profilUrl,
      required String uid})
      : super(
          password: password,
          name: name,
          email: email,
          postName: postName,
          phoneNumber: phoneNumber,
          isOnline: isOnline,
          profilUrl: profilUrl,
          uid: uid,
        );

  factory UserModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return UserModel(
        email: snapshot["email"],
        name: snapshot["name"],
        postName: snapshot["postName"],
        isOnline: snapshot["isOnline"],
        password: snapshot["password"],
        phoneNumber: snapshot["phoneNumber"],
         profilUrl: snapshot["profilUrl"],
        uid: snapshot["uid"],);
  }

  Map<String, dynamic> toDocument() {
    return {
      "email": email,
      "name": name,
      "postName": postName,
      "isOnline": isOnline,
      "password": password,
      "phneNumber": phoneNumber,
      "profilUrl": profilUrl,
      "uid":uid,
    };
  }
}
