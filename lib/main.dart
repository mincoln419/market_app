import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_app/home/cart_screen.dart';
import 'package:market_app/home/product_detail_screen.dart';
import 'package:market_app/home/widgets/seller_widget.dart';
import 'package:market_app/login/login_screen.dart';
import 'package:market_app/login/sign_up_screen.dart';

import 'home/home_screen.dart';
import 'home/product_add_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(initialLocation: "/login", routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: "cart/:uid",
          builder: (context, state) => CartScreen(
            uid: state.pathParameters['uid'] ?? "",
          ),
        ),
        GoRoute(
          path: "product",
          builder: (context, state) => ProductDetailScreen(),
        ),
        GoRoute(
          path: "product/add",
          builder: (context, state) => ProductAddScreen(),
        ),
      ],
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: "/sign_up",
      builder: (context, state) => SignUpScreen(),
    ),
  ]);

  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '메르 마켓',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
