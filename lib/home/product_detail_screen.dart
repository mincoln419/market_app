import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메르 제품 상세"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 320,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.red),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text(
                              '할인중',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '메르메르 인형',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            PopupMenuButton(itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text('리뷰등록'),
                                  onTap: () {
                                    int reviewScore = 0;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController reviewTEC =
                                            TextEditingController();
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text('리뷰등록'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: reviewTEC,
                                                ),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (index) => IconButton(
                                                      onPressed: () {
                                                        setState(
                                                          () => reviewScore =
                                                              index,
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.star,
                                                        color:
                                                            index <= reviewScore
                                                                ? Colors.orange
                                                                : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('취소'),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: Text('등록'),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  },
                                ),
                              ];
                            }),
                          ],
                        ),
                        const Text('제품상세정보'),
                        const Text('상세 description'),
                        const Row(
                          children: [
                            Text(
                              '100000원',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text('4.5'),
                          ],
                        )
                      ],
                    ),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(
                              text: '제품상세',
                            ),
                            Tab(
                              text: '리뷰',
                            ),
                          ],
                        ),
                        Container(
                          height: 500,
                          child: TabBarView(
                            children: [
                              Container(
                                child: Text('제품 상세'),
                              ),
                              Container(
                                child: Text('리뷰 화면'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red[100],
              ),
              child: Center(
                child: Text(
                  '장바구니',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
