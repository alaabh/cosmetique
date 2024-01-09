import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:projet_flutter/cubit/singup_cubit/singup_cubit.dart';

import 'package:projet_flutter/screens/login.dart';

class Singup extends StatefulWidget {
  const Singup({super.key});

  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  bool _passwordVisible = false;
  late FocusNode _focusNode;
  late FocusNode _focusNode2;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _focusNode = FocusNode();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.size.height,
          color: Colors.white,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: Get.size.height * 0.38,
                          image:
                              const AssetImage('assets/images/LoginVect.png')),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.size.width * 0.7,
                  height: Get.size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nom d'utilisateur",
                            style: TextStyle(
                                fontFamily: 'Montessarat', fontSize: 14),
                          ),
                          TextField(
                            controller: email,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(112, 75, 209, 1))),
                                hintText: 'Entrer votre email',
                                hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: Colors.grey)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mot de passe",
                            style: TextStyle(
                                fontFamily: 'Montessarat', fontSize: 14),
                          ),
                          TextField(
                            controller: password,
                            focusNode: _focusNode2,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(112, 75, 209, 1)),
                              ),
                              hintText: 'Entrer votre mot de passe',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                iconSize: 20,
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: _passwordVisible,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "username",
                            style: TextStyle(
                                fontFamily: 'Montessarat', fontSize: 14),
                          ),
                          TextField(
                            controller: username,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(112, 75, 209, 1)),
                              ),
                              hintText: 'Entrer votre username',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      BlocConsumer<SingupCubit, SingupState>(
                        listener: (context, state) {
                          if (state is SignupLoading) {
                            isloading = true;
                          } else if (state is SignupSuccess) {
                            isloading = false;
                            Get.to(Login());
                          } else if (state is SignupFailure) {
                            Get.snackbar(
                              "error",
                              state.error.toString(),
                              backgroundColor: Colors.red.withOpacity(0.2),
                              snackPosition: SnackPosition.TOP,
                            );
                            isloading = false;
                          }
                        },
                        builder: (context, state) {
                          return isloading == true
                              ? SizedBox(
                                  height: Get.size.height * 0.2,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                            color: Color.fromRGBO(
                                                112, 74, 209, 1)),
                                      ],
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 18),
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color.fromRGBO(
                                              112, 75, 209, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          side: const BorderSide(
                                            color:
                                                Color.fromRGBO(112, 75, 209, 1),
                                            width: 2.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          context.read<SingupCubit>().signup(
                                              email.text,
                                              password.text,
                                              username.text);
                                        },
                                        child: Text('Sign Up',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 13))),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
