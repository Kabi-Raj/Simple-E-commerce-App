import 'package:flutter/material.dart';
import '../tabs/CreateProduct.dart';
import '../tabs/MyProduct.dart';
import '../drawers/AllProductDrawer.dart';
import '../scopedModel/MainScopedModel.dart';

class ProductManager extends StatelessWidget {
  final MainScopedModel model;

  ProductManager(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AllProduct(),
        appBar: AppBar(
          title: Text('Product Manager'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'My Products',
                icon: Icon(Icons.view_list),
              ),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[CreateProduct(), MyProduct(model)]),
      ),
    );
  }
}
