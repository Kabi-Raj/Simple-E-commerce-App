import 'package:flutter/material.dart';
import './PriceTag.dart';
import './UiElements/LocationTag.dart';
import '../../screens/ProductDetails.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scopedModel/MainScopedModel.dart';
import '../../models/Product.dart';

class ProductCard extends StatelessWidget {
  final int productIndex;
  final List<Product> products;

  ProductCard(this.productIndex, this.products);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.height * 0.2;
    Widget _buildProductName(List<Product> products) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          products[productIndex].title,
          style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget _buildProductDetails() {
      return AnimatedContainer(
        duration: Duration(
          seconds: 2,
        ),
        curve: Curves.decelerate,
        child: IconButton(
          icon: Icon(
            Icons.info,
            color: Theme.of(context).primaryColor,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(productIndex),
              ),
            );
          },
        ),
      );
    }

    Widget _buildFavoriteProduct(List<Product> products) {
      return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color:
                  products[productIndex].isFavorite ? Colors.red : Colors.grey,
              size: 30.0,
            ),
            onPressed: () {
              model.selectProduct(productIndex);
              //model.favoriteProductSelected();
              //if(products[productIndex].productId==model.selectedProducts.productId)
              model.selectedFavoriteProduct(
                  productIndex, model.products[productIndex]);
              print('product index: $productIndex: ' +
                  'isFavorite: ${products[productIndex].isFavorite}');
            },
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Card(
        color: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Positioned(
                  child: Container(
                margin: EdgeInsets.only(top: 15.0),
                height: width,
                child: Image.asset(products[productIndex].image),
              )),
              Positioned(
                child: _buildProductDetails(),
                left: 160,
                bottom: 3,
              ),
              Positioned(
                child: _buildFavoriteProduct(products),
                left: 160,
                top: 7,
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildProductName(products),
                PriceTag(products[productIndex].price),
              ],
            ),
            LocationTag('Bangalore, Marathalli'),
            //Text(products[productIndex].userEmail),
          ],
        ),
      ),
    );
  }
}
