import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_app/home/widgets/home_widget.dart';

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
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
        ],
      ),
      body: IndexedStack(
        index: _menuIndex,
        children: [
          HomeWidget(),
          Container(
            color: Colors.indigo,
          ),
        ],
      ),
      floatingActionButton: switch (_menuIndex) {
        0 => FloatingActionButton(
          child: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        1 => FloatingActionButton(
          child: const Icon(Icons.add),
            onPressed: () {},
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
