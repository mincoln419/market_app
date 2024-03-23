import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.uid});

  final String uid;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> cartStreamItems() {
    return FirebaseFirestore.instance
        .collection('cart')
        .where('uid', isEqualTo: widget.uid)
        .orderBy('timestamp')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: cartStreamItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Cart>? items = snapshot.data?.docs.map((e) {
                          final foo = Cart.fromJson(e.data());
                          return foo.copyWith(cartDocId: e.id);
                        }).toList() ??
                        [];
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final price = ((item.product!.isSale ?? false)
                                ? ((item.product!.price! * (item.count ?? 1)) *
                                    (item.product!.saleRate! / 100))
                                : item.product!.price! ?? 0);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        item.product?.imgUrl ?? "",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${item.product?.title}'),
                                        IconButton(
                                          onPressed: () {
                                            final db = FirebaseFirestore.instance;
                                            final ref = db.collection('cart');
                                            ref.doc('${item.cartDocId}').get().then((
                                                value) {
                                              value.reference.delete();
                                            });
                                          },

                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    Text("${price.toStringAsFixed(0)} 원"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            int count = item.count ?? 1;
                                            count--;
                                            if(count < 1){
                                              count = 1;
                                            }
                                            FirebaseFirestore.instance.collection('cart')
                                                .doc('${item.cartDocId}')
                                                .update({"count": count});
                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                        ),
                                        Text('${item.count}'),
                                        IconButton(
                                          onPressed: () {
                                            int count = item.count ?? 1;
                                            count++;
                                            if(count > 99){
                                              count = 99;
                                            }
                                            FirebaseFirestore.instance.collection('cart')
                                            .doc('${item.cartDocId}')
                                            .update({"count": count});
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, _) => Divider(),
                      itemCount: snapshot.data!.docs.length,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '합계',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                StreamBuilder(
                  stream: cartStreamItems(),
                  builder: (context, snapshot) {
                    double totalPrice = 0.0;
                    if(snapshot.hasData){
                      List<Cart> items = snapshot.data?.docs.map((e){
                        final foo = Cart.fromJson(e.data());
                        return foo.copyWith(cartDocId: e.id);
                      }).toList() ?? [];

                      for(var ele in items){
                        if(ele.product?.isSale ?? false){
                          totalPrice += ((ele.product!.price! * (ele.product!.saleRate!/100))* (ele.count ?? 1));
                        }else{
                          totalPrice += ((ele.product!.price! * ele.count! ?? 1));
                        }
                      }
                    }
                    return Text(
                      '${totalPrice.toStringAsFixed(0)} 원',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }
                )
              ],
            ),
          ),
          Container(
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: const Center(
              child: Text(
                '배달주문',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
