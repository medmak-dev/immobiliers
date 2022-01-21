import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/communication/communication_cubit.dart';
import 'package:immobilier/features/chats/presentation/pages/home_page.dart';
import 'package:immobilier/injection_container.dart' as di;

import 'features/chats/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'features/chats/presentation/cubit/user/user_cubit.dart';

void main() async {
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
          BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted()),
          BlocProvider(create: (_) => di.sl<UserCubit>()..getAllUser()),
          BlocProvider(create: (_) => di.sl<CommunicationCubit>()),
          BlocProvider(create: (_) => di.sl<MyChatCubit>()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ));
  }
}
