import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:market_app/home/cart_screen.dart';
import 'package:market_app/home/product_add_screen.dart';
import 'package:market_app/home/widgets/home_widget.dart';
import 'package:market_app/home/widgets/seller_widget.dart';
import 'package:market_app/login/provider/login_provider.dart';
import 'package:market_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("메르 마켓"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
          if (_menuIndex == 0)
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
        ],
      ),
      body: IndexedStack(
        index: _menuIndex,
        children: [
          HomeWidget(),
          SellerWidget(),
        ],
      ),
      floatingActionButton: switch (_menuIndex) {
        0 => Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(userCredentialProvider);
            return FloatingActionButton(
                child: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  final uid = user?.user?.uid;
                  print('uid: $uid');
                  if(uid == null){
                    return;
                  }
                  context.go("/cart/$uid");
                },
              );
          }
        ),
        1 => FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProductAddScreen())
              );
            },
          ),
        int() => null,
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _menuIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _menuIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            label: "홈",
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront),
            label: "사장님(판매자)",
          ),
        ],
      ),
    );
  }
}
