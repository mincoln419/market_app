import 'package:flutter/material.dart';
import 'package:market_app/login/login_screen.dart';
import 'package:market_app/login/sign_up_screen.dart';

import 'home/home_screen.dart';
import 'home/product_add_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: '메르 마켓',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductAddScreen(),
    );
  }
}
