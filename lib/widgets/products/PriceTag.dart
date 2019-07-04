import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Colors.blue),
      margin: EdgeInsets.all(10.0),
      child: Text(
        '₹ $price',
        style: TextStyle(
            fontSize: 15.0, fontFamily: 'Oswald', fontWeight: FontWeight.bold),
      ),
    );
  }
}
