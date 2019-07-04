import 'package:flutter/material.dart';
import './screens/HomePage.dart';
import './screens/ProductsList.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scopedModel/MainScopedModel.dart';
import './screens/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainScopedModel>(
      model: MainScopedModel(),
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Colors.deepPurple,
          primaryColor: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/product list': (context) => ProductsList(),
          '/home': (context) => HomePage(),
          //'/product details':(context)=>ProductDetail(_deleteProduct,product: _product,index: _product.indexOf(_product),),
          //'/home':(context)=>LoginPage(),
          '/': (BuildContext context) => LoginPage()
        },
      ),
    );
  }
}
