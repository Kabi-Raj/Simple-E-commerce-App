import 'package:flutter/material.dart';
import '../widgets/products/ProductCard.dart';
import '../scopedModel/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/Product.dart';

class ProductsList extends StatelessWidget {
  Widget _productBuild(List<Product> products, BuildContext context) {
    final width = MediaQuery.of(context).size.height*0.37;
    Widget _products;
    if (products.length > 0)
      _products = Container(
        height: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              //print('itemid: $index');
              ProductCard(index, products),
          itemCount: products.length,
        ),
      );
    else
      _products = Center(
        child: Text(
          'No products found, add some products',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    return _products;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return _productBuild(
          model.products, context); //getter products is called to retrieve data
    });
  }
}
