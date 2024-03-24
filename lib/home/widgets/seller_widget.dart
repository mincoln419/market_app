import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/product.dart';

class SellerWidget extends StatefulWidget {
  const SellerWidget({super.key});

  @override
  State<SellerWidget> createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  TextEditingController searchTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            controller: searchTec,
            leading: Icon(Icons.search),
            onChanged: (s) {
              setState(() {});
            },
            hintText: '상품명 입력',
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () async {
                  List<String> categories = ['정육', '과일', '과자', '쿠키', '아이스크림'];
                  final ref = FirebaseFirestore.instance.collection('category');
                  final tmp = await ref.get();

                  for (var element in tmp.docs) {
                    await element.reference.delete();
                  }
                  for (var element in categories) {
                    await ref.add({'title': element});
                  }
                },
                child: Text("카테고리 일괄등록"),
              ),
              ElevatedButton(
                onPressed: () {
                  TextEditingController tec = TextEditingController();
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: TextField(
                        controller: tec,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            if (tec.text.isNotEmpty) {
                              await addCartegories(tec.text.trim());
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('등록'),
                        )
                      ],
                    ),
                  );
                },
                child: Text("카테고리 등록"),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "상품목록",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: streamProducts(searchTec.text),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data?.docs
                        .map((e) =>
                            Product.fromJson(e.data() as Map<String, dynamic>)
                                .copyWith(docId: e.id))
                        .toList();
                    return ListView.builder(
                      itemCount: items?.length,
                      itemBuilder: (context, index) {
                        final item = items?[index];
                        return GestureDetector(
                          onTap: () {
                            print(item?.docId);
                            context.go("/product", extra: items![index]);
                          },
                          child: Container(
                            height: 120,
                            margin: const EdgeInsets.only(bottom: 16),
                            color: Colors.orange,
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(item?.imgUrl ??
                                          "https://cdn.pixabay.com/photo/2024/03/05/19/26/duck-8615153_1280.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item?.title ?? "제품 명",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: Text("리뷰"),
                                                ),
                                                PopupMenuItem(
                                                  child: Text('수정하기'),
                                                  onTap: () async {
                                                    final ref =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products');
                                                    await ref
                                                        .doc(item?.docId)
                                                        .update(item!
                                                            .copyWith(
                                                              title: "milk kim",
                                                              price: 10000,
                                                            )
                                                            .toJson());
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  child: Text("삭제"),
                                                  onTap: () async {
                                                    final db = FirebaseFirestore
                                                        .instance;
                                                    await db
                                                        .collection('products')
                                                        .doc(item?.docId)
                                                        .delete();
                                                    final productCategory =
                                                        await db
                                                            .collection(
                                                                'products')
                                                            .doc(item?.docId)
                                                            .collection(
                                                                'category')
                                                            .get();
                                                    final foo = productCategory
                                                        .docs.first;
                                                    final categoryId =
                                                        foo.data()['docId'];
                                                    final bar = await db
                                                        .collection('category')
                                                        .doc(categoryId)
                                                        .collection('products')
                                                        .where('docId',
                                                            isEqualTo:
                                                                item?.docId);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text("${item?.price}원" ?? "가격"),
                                        Text(switch (item?.isSale) {
                                          true => "할인 중 : ${item?.saleRate} %",
                                          false => "정상가격",
                                          _ => "??",
                                        }),
                                        Text("재고수량: ${item?.stock} 개"),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

Future addCartegories(String title) async {
  final db = FirebaseFirestore.instance;
  final ref = db.collection("category");
  await ref.add({"title": title});
}

Future<List<Product>?> fetchProducts() async {
  final db = FirebaseFirestore.instance;
  final resp = await db.collection('products').orderBy('timestamp').get();
  List<Product> items = [];
  for (var doc in resp.docs) {
    final item = Product.fromJson(doc.data());
    final realItem = item.copyWith(docId: doc.id);
    items.add(item);
  }
}

Stream<QuerySnapshot> streamProducts(String query) {
  final db = FirebaseFirestore.instance;
  if (query.isNotEmpty) {
    return db
        .collection('products')
        .orderBy("title")
        .startAt([query]).endAt([query + "\uf8ff"]).snapshots();
  }
  return db.collection('products').orderBy("timestamp").snapshots();
}
