import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immobilier/features/chats/domain/entities/user_entity.dart';
import 'package:immobilier/features/chats/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/auth/auth_state.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_cubit.dart';
import 'package:immobilier/features/chats/presentation/cubit/user/user_state.dart';
import 'package:immobilier/features/chats/presentation/pages/home_page.dart';
import 'package:immobilier/features/chats/presentation/screens/sign_in_screen.dart';
import 'package:immobilier/features/chats/presentation/widgets/circular_progress.dart';
import 'package:immobilier/features/chats/presentation/widgets/loader.dart';
import 'package:immobilier/features/chats/presentation/widgets/text_custum.dart';
import 'package:immobilier/features/chats/presentation/widgets/theme/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  late UserEntity user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void signUpWithEmailFunction(
      {required String email,
      required String password,
      required String name,
      required String prenom,
      required String phone}) {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        prenom.isNotEmpty &&
        phone.isNotEmpty) {
      user = UserEntity(
        name: name,
        postName: prenom,
        email: email,
        password: password,
        isOnline: true,
        phoneNumber: phone,
        profilUrl: " ",
        uid: " ",
        time: Timestamp.now(),
      );
      BlocProvider.of<AuthCubit>(context).signUpWithEmail(user: user);
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      //on utilise le block Consumer lorsque nous voulons dessiner un widget et executer certaine action en fonction des nouveau etat qui arrive
      body: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
        if (authState is Authentificated) {
          return HomePage(
            userUidInfo: authState.uid,
          );
        }
        if (authState is UnAuthentificated) {
          print("----> retourne le formulaire");
          return formulaireInscription();
        }

        print("----> retourne la circularProgresse indicator");
        return const Center(
          child: CircularLoader(),
        );
      },

          /// dans le listener on y retourne un wiidget relative au changement d'etat
          /// voyer blockListener si vous vouler faire qu'elque chose en reponse a des changement d'etat tel que la navigation, l'affichage d'une boite de dialogue

          listener: (context, userState) {
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

          print("----> le loggetIn du  listener");
        }
      }),
    );
  }

  Widget formulaireInscription() {
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
                          "Inscription",
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
                                setState(() {
                                  signUpWithEmailFunction(
                                      email: _emailController.text,
                                      name: _nameController.text,
                                      password: _passwordController.text,
                                      prenom: _prenomController.text,
                                      phone: _phoneNumberController.text);
                                  _emailController.clear();
                                  _passwordController.clear();
                                  _phoneNumberController.clear();
                                  _nameController.clear();
                                  _prenomController.clear();
                                });
                              }

                              //pour fermer le context courant avant de poucher la ome page, preferable d'utiliser la navigation par route pour eviter les context non fermer ou des vue non detruite
                            },
                            child: TextCustum("Inscription")),
                      ),
                      Expanded(
                          child: Container(
                              child: Column(
                        children: [
                          TextCustum(
                            "Vous avez deja un compte?",
                            size: 11,
                          ),
                          TextButton(
                            onPressed: () {
                              circleProgress();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              })); // preferable d'utiliser la navigation par route
                              _emailController.clear();
                              _passwordController.clear();
                              _phoneNumberController.clear();
                              _nameController.clear();
                              _prenomController.clear();
                            },
                            child: TextCustum(
                              "Se Connecter",
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
              //nom
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
                      controller: _nameController,

                      validator: (valueName) {
                        if (valueName!.isEmpty) {
                          return "Nom Invalide";
                        } else {
                          return null;
                        }
                      },

                      onChanged: (String nom) {
                        print("nom=$nom");
                      },
                      cursorColor: Colors.grey,
                      //autocorrect: true,

                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 22,
                        ),
                        hintText: "Nom",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )),

              //prenom
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
                      controller: _prenomController,
                      textCapitalization: TextCapitalization.words,
                      validator: (valuePrenom) {
                        if (valuePrenom!.isEmpty) {
                          return "Prenom Invalide";
                        } else {
                          return null;
                        }
                      },

                      onChanged: (String prenom) {
                        print("prenom=$prenom");
                      },
                      cursorColor: Colors.grey,
                      //autocorrect: true,

                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 22,
                        ),
                        hintText: "Prenom",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )),

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
                      validator: (valueEmail) {
//verifie si l'aadresse entrez est valide
                        if (valueEmail!.isEmpty) {
                          return 'Ce champ est obligatioire';
                        }
                        final RegExp nameExp = RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                        if (!nameExp.hasMatch(valueEmail)) {
                          return 'Address email invalide';
                        }
                        return null;
                      },
                      controller: _emailController,
                      onChanged: (String email) {
                        print("Email=$email");
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

              //Numero telephone

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
                      controller: _phoneNumberController,

                      onChanged: (String phone) {
                        print("phone=$phone");
                      },
                      cursorColor: Colors.grey,
                      //autocorrect: true,

                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.phone_enabled_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        hintText: "Telepone +237",
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
