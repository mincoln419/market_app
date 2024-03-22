import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:market_app/home/product_detail_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  PageController pageController = PageController();
  int bannerIndex = 0;

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
                  color: Colors.red,
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
                  color: Colors.orange,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductDetailScreen()));
                        },
                        child: Container(
                          width: 160,
                          height: 100,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
