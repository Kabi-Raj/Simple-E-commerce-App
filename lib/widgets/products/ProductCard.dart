import 'package:flutter/material.dart';
import './PriceTag.dart';
import './UiElements/LocationTag.dart';
import '../../screens/ProductDetails.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scopedModel/MainScopedModel.dart';
import '../../models/Product.dart';

class ProductCard extends StatelessWidget {
  final String productID;
  final List<Product> products;

  ProductCard(this.productID, this.products);

  @override
  Widget build(BuildContext context) {
    Product product = products.firstWhere((Product p) {
      return p.productId == productID;
    });
    //final width = MediaQuery.of(context).size.height * 0.2;
    Widget _buildProductName(List<Product> products) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          product.title,
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
                builder: (context) => ProductDetail(product),
              ),
            );
          },
        ),
      );
    }

    Widget _buildFavoriteProduct() {
      return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: product.isFavorite ? Colors.red : Colors.blueGrey,
              size: 30.0,
            ),
            onPressed: () {
              model.selectProduct(product.productId);
              //model.favoriteProductSelected();
              //if(products[productIndex].productId==model.selectedProducts.productId)
              model.selectedFavoriteProduct(product);
              print('product index: $productID: ' +
                  'isFavorite: ${product.isFavorite}');
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
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: FadeInImage(
                    placeholder: AssetImage('assets/placeholder.png'),
                    fit: BoxFit.fill,
                    image: NetworkImage(product.image)),
              )),
              Positioned(
                child: _buildProductDetails(),
                right: 10,
                bottom: 0,
              ),
              Positioned(
                child: _buildFavoriteProduct(),
                right: 10,
                top: 7,
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildProductName(products),
                PriceTag(product.price),
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
