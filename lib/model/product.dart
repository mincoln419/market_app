import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

part 'product.g.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    String? docId,
    String? title,
    String? description,
    int? price,
    bool? isSale,
    int? stock,
    double? saleRate,
    String? imgUrl,
    int? timestamp,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
