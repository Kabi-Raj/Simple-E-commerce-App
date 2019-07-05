import 'package:flutter/material.dart';

class Product {
  final String title, description, price, image, userEmail, productId;
  final bool isFavorite;

  Product(
      {@required this.productId,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      this.isFavorite = false});
}
