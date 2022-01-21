import 'dart:ffi';
import 'dart:io';

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
        emit(AuthAuthentificated(uid: uid));
      } else {
        emit(AuthUnAuthentificated());
      }
    } catch (_) {
      emit(AuthUnAuthentificated());
    }
  }

  Future<void> loggetIn() async {
    try {
      final uid = await getCurrentUidUsecase.call();
      emit(AuthAuthentificated(uid: uid));
    } catch (_) {
      emit(AuthUnAuthentificated());
    }
  }

  Future<void> loggetOut() async {
    try {
      await signOutUsecase.call();
      emit(AuthUnAuthentificated());
    } catch (_) {}
  }

  Future<void> signInWithEmail({required UserEntity user}) async {
    try {
      String uid = await getCurrentUidUsecase.call();
      await signInWithEmailUsecase.call(userEntity: user);
      emit(AuthAuthentificated(uid: uid));
    } on SocketException catch (_) {
      emit(AuthUnAuthentificated());
    } catch (_) {
      emit(AuthUnAuthentificated());
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
          uid:" ");
      await signUpWithEmailUsecase.call(userEntity: newUser).whenComplete(() {
        getCreateCurrentUserUsecase.call(user: newUser);
      });
      // getCreateCurrentUserUsecase.call(user: user);
      String uid = await getCurrentUidUsecase.call();
      emit(AuthAuthentificated(uid: uid));
    } on SocketException catch (_) {
      emit(AuthUnAuthentificated());
    } catch (_) {
      emit(AuthUnAuthentificated());
    }
  }
}
