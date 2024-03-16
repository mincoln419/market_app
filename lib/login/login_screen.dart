import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

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
                      onPressed: () {},
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
                    onPressed: () {},
                    child: Text("계정이 없나요? 회원가입"),
                  ),
                  const Divider(),
                  Image.asset("assets/images/btn_google_signin.png"),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
