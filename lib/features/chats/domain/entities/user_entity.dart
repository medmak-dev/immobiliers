import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String postName;
  final String phoneNumber;
  final String email;
  final String password;
  final String profilUrl;
  final bool isOnline;
  final String uid;
  final Timestamp time;

  const UserEntity({
    required this.name,
    required this.postName,
    required this.email,
    required this.password,
    required this.isOnline,
    required this.phoneNumber,
    required this.profilUrl,
    required this.uid,
    required this.time,
  });

  @override
  List<Object?> get props => [
        name,
        postName,
        phoneNumber,
        password,
        email,
        profilUrl,
        isOnline,
        uid,
        time
      ];
}
