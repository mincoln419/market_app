import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential);
      userCredential = credential;
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.toString());
      } else if (e.code == 'wrong-password') {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/market_log.png",
                width: 120,
                height: 120,
              ),
              const Text("메르 마트",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  )),
              const SizedBox(
                height: 64,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "이메일",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "이메일주소를 입력하세요";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: pwdTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "비밀번호",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력하세요";
                          }
                          return null;
                        },
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final result = await signIn(
                                emailTextController.text.trim(),
                                pwdTextController.text.trim(),
                              );
                              if (result == null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('로그인 실패')));
                                return;
                              }
                              if (context.mounted) {
                                context.go("/");
                              }
                            }
                          },
                          height: 48,
                          minWidth: double.infinity,
                          color: Colors.red,
                          child: const Text(
                            "로그인",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push("/sign_up"),
                        child: Text("계정이 없나요? 회원가입"),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () async {
                          final userCredential = await signInWithGoogle();
                          if (userCredential == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('로그인 실패-google'),
                              ),
                            );
                            return;
                          }
                          if(context.mounted){
                            context.go("/");
                          }
                        },
                        child:
                            Image.asset("assets/images/btn_google_signin.png"),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
