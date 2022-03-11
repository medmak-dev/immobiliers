import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/usecases/get_create_current_user_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_current_uid_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/is_sign_in_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_out_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmailUsecase signInWithEmailUsecase;
  final SignUpWithEmailUsecase signUpWithEmailUsecase;
  final SignOutUsecase signOutUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUsecase;
  final IsSignInUsecase isSignInUsecase;
  AuthCubit({
    required this.getCreateCurrentUserUsecase,
    required this.signInWithEmailUsecase,
    required this.signOutUsecase,
    required this.signUpWithEmailUsecase,
    required this.getCurrentUidUsecase,
    required this.isSignInUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUsecase.call();
      final uid = await getCurrentUidUsecase.call();
      if (isSignIn) {
        emit(Authentificated(uid: uid));
      } else {
        emit(UnAuthentificated());
      }
    } on SocketException catch (_) {
      emit(UnAuthentificated());
    } catch (_) {
      emit(UnAuthentificated());
    }
  }

  Future<void> loggetIn() async {
    try {
      final uid = await getCurrentUidUsecase.call();
      emit(Authentificated(uid: uid));
    } catch (_) {
      emit(UnAuthentificated());
    }
  }

  Future<void> loggetOut() async {
    try {
      await signOutUsecase.call();
      emit(UnAuthentificated());
    } catch (_) {
      emit(UnAuthentificated());
    }
  }

  Future<void> signInWithEmail({required UserEntity user}) async {
    try {
      await signInWithEmailUsecase.call(userEntity: user);
      final String uid = await getCurrentUidUsecase.call();
      emit(Authentificated(uid: uid));
      print("Connexion réussi Current uid $uid");
    } on SocketException catch (_) {
      emit(UnAuthentificated());
      emit(AuthSucces());
    } catch (_) {
      emit(UnAuthentificated());
    }
  }

  Future<void> signUpWithEmail({required UserEntity user}) async {
    try {
      UserEntity newUser = UserEntity(
        name: user.name,
        postName: user.postName,
        email: user.email,
        password: user.password,
        isOnline: true,
        phoneNumber: user.phoneNumber,
        profilUrl: " ",
        uid: " ",
        time: Timestamp.now(),
      );
      await signUpWithEmailUsecase.call(userEntity: newUser);
      //aprés que l'enregistrement soit terminer on crée  un utilisateur
      await getCreateCurrentUserUsecase.call(user: newUser);
      final String uid = await getCurrentUidUsecase.call();
      emit(Authentificated(uid: uid));
      emit(AuthSucces());
      print("Inscription reussi Current uid $uid");
    } on SocketException catch (_) {
      emit(UnAuthentificated());
    } catch (_) {
      emit(UnAuthentificated());
    }
  }
}
