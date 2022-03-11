import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';

class MainScreen extends StatefulWidget {
  final String userUidInfo;
  const MainScreen({Key? key, required this.userUidInfo}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Main")),
    );
  }
}
