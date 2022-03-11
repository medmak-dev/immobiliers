import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/data/models/user_model.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_state.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_state.dart';
import 'package:immobilier/features/chats/presentation/pages/home_page.dart';
import 'package:immobilier/features/chats/presentation/screens/sign_in_screen.dart';
import 'package:immobilier/features/chats/presentation/screens/welcome_screen.dart';
import 'package:immobilier/features/chats/presentation/widgets/circular_progress.dart';
import 'package:immobilier/features/chats/presentation/widgets/loader.dart';
import 'injection_container.dart' as di;

import 'features/chats/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'features/chats/presentation/cubit/user/user_cubit.dart';

//BlockBuilder est utiliser lorsque nous voulons dessiner un widget en foction d'un etat
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>()
                ..appStarted()), //le deux point signifi que ca Crée la methode et ca la renvoi
          BlocProvider<UserCubit>(
              create: (_) => di.sl<UserCubit>()..getAllUser()),
          BlocProvider<CommunicationCubit>(
              create: (_) => di.sl<CommunicationCubit>()),
          BlocProvider<MyChatCubit>(create: (_) => di.sl<MyChatCubit>()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (context) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authentificated) {
                  return HomePage(
                    userUidInfo: authState.uid,
                  );
                }
                //si on est pas connecter, on reste sur la parge  sur la page d'accueil
                if (authState is UnAuthentificated) {
                  return const SignInScreen();
                }
                //sinon on retourne un container vide
                return const Center(
                  child: CircularLoader(),
                );
              });
            }
          },
        ));
  }
}
