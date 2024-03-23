import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_app/home/product_detail_screen.dart';
import 'package:market_app/model/product.dart';

import '../../model/category.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  PageController pageController = PageController();
  int bannerIndex = 0;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCategories() {
    return FirebaseFirestore.instance.collection('category').snapshots();
  }

  Future<List<Product>> specialSales() async {
    final dbRef = FirebaseFirestore.instance.collection('products');
    final saleItems =
        await dbRef.where('isSale', isEqualTo: true).orderBy('saleRate').get();
    List<Product> products = [];
    for (var ele in saleItems.docs) {
      final item = Product.fromJson(ele.data());
      final copyItem = item.copyWith(docId: ele.id);
      products.add(copyItem);
    }
    return products;
  }

  List<Category> categoryItems = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 140,
            color: Colors.indigo,
            margin: const EdgeInsets.only(bottom: 8),
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Image.asset("assets/images/market_log.png"),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Image.asset("assets/images/btn_google_signin.png"),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Image.asset("assets/images/market_log.png"),
                ),
              ],
              onPageChanged: (idx) {
                setState(() {
                  bannerIndex = idx;
                });
              },
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: bannerIndex,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "카테고리",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("더보기"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                //TODO: 카테고리목록받아오기
                Container(
                  height: 240,
                  child: StreamBuilder(
                    stream: streamCategories(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        categoryItems.clear();
                        final docs = snapshot.data;
                        final docItems = docs?.docs ?? [];
                        for (var doc in docItems) {
                          categoryItems.add(
                            Category(
                              docId: doc.id,
                              title: doc.data()['title'],
                            ),
                          );
                        }
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: categoryItems.length,
                            itemBuilder: (context, index) {
                              final item = categoryItems[index];
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    item.title ?? '카테고리',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "오늘의 특가",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("더보기"),
                    ),
                  ],
                ),
                Container(
                  height: 240,
                  width: double.infinity,
                  child: FutureBuilder(
                      future: specialSales(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final items = snapshot.data ?? [];
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () {
                                  context.go("/product", extra: item);
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 160,
                                        margin: EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(item.imgUrl ?? ""),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.title ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text('정상가격: ${item.price ?? ""} 원', style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                    ),),
                                    Text(
                                        '할인가격: ${(item.price! * (item.saleRate! / 100)).toStringAsFixed(0)} 원'),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
