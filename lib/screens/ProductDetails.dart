import 'package:flutter/material.dart';
import 'dart:async';
import '../models/Product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      //getter used to get the product
      return Scaffold(
        appBar: AppBar(
          title: Text('Product detail'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5.0),
              child: Image.network(
                product.image,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
            ),
            Text(
              product.description,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
            ),
          ],
        ),
      );
    }), onWillPop: () {
      Navigator.pop(context, true); //to don't remove product card
      return Future.value(
          false); //false bcz already page is removed, otherwise app crashes
    });
  }
}
