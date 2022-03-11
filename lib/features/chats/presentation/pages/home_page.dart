import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';
import 'package:immobilier/features/chats/presentation/pages/chat_page.dart';
import 'package:immobilier/features/chats/presentation/pages/favorie.dart';
import 'package:immobilier/features/chats/presentation/pages/profil_page.dart';
import 'package:immobilier/features/chats/presentation/screens/main_screen.dart';
import 'package:immobilier/features/chats/presentation/screens/welcome_screen.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';

class HomePage extends StatefulWidget {
  final String userUidInfo;
  const HomePage({Key? key, required this.userUidInfo, userInfo})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logOut() async {
    return BlocProvider.of<AuthCubit>(context).loggetOut();
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUser();
    super.initState();
  }

  int currentPageIndex = 0;

  List<Widget> get _pages => [
        MainScreen(
          userUidInfo: widget.userUidInfo,
        ),
        MyChatPage(
          userUidInfo: widget.userUidInfo,
        ),
        const FavoritePage(),
        const ProfilePage(),
      ];
  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: TextCustum(
          "HimoCam",
          color: Colors.black,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.black,
            )),
        /**
         * actions: [
            IconButton(
            onPressed: () {},
            icon: const Icon(
            Icons.notifications,
            color: Colors.black,
            )),
            ],
         */
      ),
      body: Center(
        child: _pages.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 10.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          // showUnselectedLabels: false,
          //showSelectedLabels: false,
          backgroundColor: Colors.grey[100],
          currentIndex: currentPageIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Accueil",
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.black,
                )),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble),
                label: "Chat",
                activeIcon: Icon(
                  CupertinoIcons.chat_bubble_fill,
                  color: Colors.black,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: "Favorie",
                activeIcon: Icon(
                  Icons.favorite,
                  color: Colors.black,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile",
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                )),
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Center(
          child: Icon(
            Icons.add,
            size: 24.0,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        mini: true, //reduire la taille
        elevation: 10,

        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //on centre notre floatingActionButton
    );
  }
}
