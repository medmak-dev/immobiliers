import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immobilier/features/chats/data/models/user_model.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_state.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_state.dart';
import 'package:immobilier/features/chats/presentation/pages/home_page.dart';
import 'package:immobilier/features/chats/presentation/screens/sign_in_screen.dart';
import 'package:immobilier/features/chats/presentation/screens/sign_up_screen.dart';
import 'package:immobilier/features/chats/presentation/widgets/circular_progress.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';
import 'package:flutter/animation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool visible = true;
  void passVisible() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  late UserEntity user;

  void signInWithEmailFunction(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      user = UserEntity(
        name: "",
        postName: "",
        email: email,
        password: password,
        isOnline: true,
        phoneNumber: "",
        profilUrl: "",
        uid: "",
        time: Timestamp.now(),
      );
      BlocProvider.of<AuthCubit>(context)
          .signInWithEmail(user: user)
          .whenComplete(() {
        print("----> Connexion Succes");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
        if (authState is Authentificated) {
          return HomePage(
            userUidInfo: authState.uid,
          );
        }

        if (authState is UnAuthentificated) {
          print("----> retourne le formulaire");
          circleProgress();
          return formulaireConnexion();
        }

        print("----> retourne le formulaire au listener");
        return formulaireConnexion();
      }, listener: (context, userState) {
        if (userState is AuthSucces) {
          BlocProvider.of<AuthCubit>(context).loggetIn();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.transparent,
              content: Text(
                "Bienvenue parmie nous ",
                style: TextStyle(
                  color: Colors.black,
                ),
              )));

          print("----> loggetIn");
        }
      }),
    );
  }

  Widget formulaireConnexion() {
    return Stack(
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
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.6),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.1),
                  Colors.black.withOpacity(0.1),
                ]),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: TextCustum(
                          "Connexion",
                          size: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                      //le spacer prend toute la place disponible autant que le expanded
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Fofrmulaire de validation
                  formSignIn(),

                  const SizedBox(
                    height: 20,
                  ),
                  //bouton de validation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              elevation: 8,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                signInWithEmailFunction(_emailController.text,
                                    _passwordController.text);
                                _emailController.clear();
                                _passwordController.clear();
                              }
                            },
                            child: TextCustum("Connexion")),
                      ),
                      Expanded(
                          child: Container(
                              child: Column(
                        children: [
                          TextCustum(
                            "Vous n'avez pas de compte?",
                            size: 11,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const SignUpScreen();
                              }));
                              _emailController.clear();
                              _passwordController.clear();
                            },
                            child: TextCustum(
                              "S'inscrire",
                              size: 12,
                            ),
                          ),
                        ],
                      )))
                    ],
                  )
                ],
              )),
        )
      ],
    );
  }

  Widget formSignIn() {
    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              //Email
              Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.2)
                          ]),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (valueEmail) {
//verifie si l'aadresse entrez est valide
                        if (valueEmail == null || valueEmail.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        final RegExp nameExp = RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                        if (!nameExp.hasMatch(valueEmail))
                          return 'Adresse email invalide';
                        return null;
                      },

                      onEditingComplete: () {
                        print("Email=$_emailController.text");
                      },
                      cursorColor: Colors.grey,
                      //autocorrect: true,

                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )),

              //Mot de passe
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.2)
                          ]),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                      controller: _passwordController,

                      validator: (valuePass) => (valuePass!.isEmpty)
                          ? "Mot de passe invalide"
                          : (valuePass.length < 6)
                              ? "Mot de passe court"
                              : null,

                      onEditingComplete: () {
                        print("password=$_passwordController.text");
                      },
                      cursorColor: Colors.grey,
                      //autocorrect: true,

                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: visible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            (visible)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 22,
                          ),
                          color: Colors.grey,
                          onPressed: passVisible,
                        ),
                        hintText: "Mot de passe",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
