import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../model/category.dart';
import '../model/product.dart';
import 'camera_example_page.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isSale = false;

  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Uint8List? imageData;
  XFile? image;

  Category? selectedCategory;

  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController stockTEC = TextEditingController();
  TextEditingController salePercentTEC = TextEditingController();

  List<Category> categoryItems = [];

  Future<List<Category>> _fetchCategories() async {
    final resp = await db.collection('category').get();
    for (var doc in resp.docs) {
      categoryItems.add(Category(
        docId: doc.id,
        title: doc.data()['title'],
      ));
    }
    setState(() {
      selectedCategory = categoryItems.first;
    });
    return categoryItems;
  }

  Future<Uint8List> imageCompressList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 50);
    return result;
  }

  Future addProduct() async {
    if (imageData != null) {
      final storageRef = storage.ref().child(
          "${DateTime.now().millisecondsSinceEpoch}_${image?.name ?? "??"}");
      final compressedData = await imageCompressList(imageData!);
      await storageRef.putData(compressedData);
      final downloadLink = await storageRef.getDownloadURL();
      final sampleData = Product(
        title: titleTEC.text,
        description: descriptionTEC.text,
        price: int.parse(priceTEC.text),
        saleRate: salePercentTEC.text.isNotEmpty
            ? double.parse(salePercentTEC.text)
            : 0.0,
        stock: int.parse(stockTEC.text),
        isSale: isSale,
        imgUrl: downloadLink,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      final doc = await db.collection('products').add(sampleData.toJson());
      await doc.collection('category').add(selectedCategory?.toJson() ?? {});
      final categoRef = db.collection('category').doc(selectedCategory?.docId);
      await categoRef.collection("products").add({"docId": doc.id});
    }
  }

  Future addProducts() async {
    if (imageData != null) {
      final storageRef = storage.ref().child(
          "${DateTime.now().millisecondsSinceEpoch}_${image?.name ?? "??"}");
      final compressedData = await imageCompressList(imageData!);
      await storageRef.putData(compressedData);
      final downloadLink = await storageRef.getDownloadURL();

      for (var i = 0; i < 10; i++) {
        final sampleData = Product(
          title: titleTEC.text + ' $i',
          description: descriptionTEC.text,
          price: int.parse(priceTEC.text),
          saleRate: salePercentTEC.text.isNotEmpty
              ? double.parse(salePercentTEC.text)
              : 0.0,
          stock: int.parse(stockTEC.text),
          isSale: isSale,
          imgUrl: downloadLink,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        final doc = await db.collection('products').add(sampleData.toJson());
        await doc.collection('category').add(selectedCategory?.toJson() ?? {});
        final categoRef =
            db.collection('category').doc(selectedCategory?.docId);
        await categoRef.collection("products").add({"docId": doc.id});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품추가'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CameraExamplePage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.camera_alt_outlined)),
          IconButton(
              onPressed: () async {
                await addProducts().then((value) => Navigator.of(context).pop());
              },
              icon: Icon(Icons.batch_prediction)),
          IconButton(
              onPressed: () async{
                await addProduct().then((value) => Navigator.of(context).pop());
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                image = await picker.pickImage(source: ImageSource.gallery);
                print('${image?.name}, ${image?.path}');
                imageData = await image?.readAsBytes();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 240,
                  width: 240,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200]!,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: imageData == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text('제품(상품) 이미지 추가'),
                          ],
                        )
                      : Image.memory(imageData!, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "기본정보",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleTEC,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "상품명",
                        hintText: "상품명을 입력하세요",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "필수값을 입력하세요";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: descriptionTEC,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "상품 설명",
                      ),
                      maxLength: 254,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "상품설명을 입력하세요.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: priceTEC,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "가격(단가)",
                        hintText: "개별단가",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "필수 입력 항목입니다";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: stockTEC,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "수량",
                        hintText: "입고 및 재고 수량",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "수량을 입력해주세요";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SwitchListTile(
                      value: isSale,
                      onChanged: (v) {
                        setState(() {
                          isSale = v;
                        });
                      },
                      title: Text("할인여부"),
                    ),
                    if (isSale)
                      TextFormField(
                        controller: salePercentTEC,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "할인율",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return null;
                        },
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "카테고리 선택",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    categoryItems.isNotEmpty
                        ? DropdownButton<Category>(
                            isExpanded: true,
                            value: selectedCategory,
                            items: categoryItems
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text("${e.title}"),
                                    ))
                                .toList(),
                            onChanged: (s) {
                              setState(() {
                                selectedCategory = s;
                              });
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
