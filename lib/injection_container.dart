import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:immobilier/features/chats/data/datasources/firebase_remote_datasource.dart';
import 'package:immobilier/features/chats/data/datasources/firebase_remote_datasource_impl.dart';
import 'package:immobilier/features/chats/data/repositories/firebase_repositorie_impl.dart';
import 'package:immobilier/features/chats/domain/repositories/firebase_repository.dart';
import 'package:immobilier/features/chats/domain/usecases/add_to_my_chat_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/create_on_to_one_chat_channel_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_all_user_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_create_current_user_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_current_uid_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_my_chat_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_one_to_one_single_user_chat_chat_channel_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/get_text_message_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/is_sign_in_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/send_text_message_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_out_usecase.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCreateCurrentUserUsecase: sl.call(),
      signInWithEmailUsecase: sl.call(),
      signOutUsecase: sl.call(),
      signUpWithEmailUsecase: sl.call(),
      getCurrentUidUsecase: sl.call(),
      isSignInUsecase: sl.call()));

  sl.registerFactory<CommunicationCubit>(() => CommunicationCubit(
      getOneToOneSingleUserChatChannelUsecase: sl.call(),
      getTextMessageUsecase: sl.call(),
      sendTextMessageUsecase: sl.call(),
      addToMyChatUsecase: sl.call()));

  sl.registerFactory<UserCubit>(() => UserCubit(
      getAllUserUsecase: sl.call(),
      createOneToOneChatChannelUsecase: sl.call()));

  sl.registerFactory<MyChatCubit>(() => MyChatCubit(
      getMyChatUsecase: sl.call(), getCurrentUidUsecase: sl.call()));

  sl.registerLazySingleton<SendTextMessageUsecase>(
      () => SendTextMessageUsecase(repository: sl.call()));
  sl.registerLazySingleton<AddToMyChatUsecase>(
      () => AddToMyChatUsecase(repository: sl.call()));
  sl.registerLazySingleton<CreateOneToOneChatChannelUsecase>(
      () => CreateOneToOneChatChannelUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetAllUserUsecase>(
      () => GetAllUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
      () => GetCreateCurrentUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUsecase>(
      () => GetCurrentUidUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetMyChatUsecase>(
      () => GetMyChatUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetOneToOneSingleUserChatChannelUsecase>(
      () => GetOneToOneSingleUserChatChannelUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetTextMessageUsecase>(
      () => GetTextMessageUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignInWithEmailUsecase>(
      () => SignInWithEmailUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUsecase>(
      () => SignOutUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignUpWithEmailUsecase>(
      () => SignUpWithEmailUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUsecase(repository: sl.call()));

//remote data
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()));

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl.call()));
//external
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
}
