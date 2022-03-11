import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/screens/sign_in_screen.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';
import 'package:immobilier/features/chats/presentation/widgets/theme/styles.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final formKey = GlobalKey<FormState>();
  UserEntity? user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController __nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool visible = true;
  void passVisible() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _prenomController.dispose();
    _passwordController.dispose();
    __nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/font.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                  ]),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: TextCustum(
                          "HimoCam",
                          size: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: TextCustum(
                          "La recherche et la vente de vos bien immobilier devient un jeux d'enfant",
                          size: 13,
                          letterSpacing: 0.1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //bouton de validation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(12),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              elevation: 8,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }));
                            },
                            child: TextCustum("Commencer")),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
