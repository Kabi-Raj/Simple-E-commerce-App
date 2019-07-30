import 'package:flutter/material.dart';
import '../widgets/products/ProductCard.dart';
import '../scopedModel/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsList extends StatefulWidget {
  final MainScopedModel model;

  ProductsList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductsList> {
  @override
  initState() {
    widget.model.fetchProductData();
    super.initState();
  }

  Widget _productBuild(MainScopedModel model, BuildContext context) {
    //final width = MediaQuery.of(context).size.height * 0.37;
    Widget _content = Center(
      child: Text(
        'No products found, add some products',
        style: TextStyle(fontSize: 20.0),
      ),
    );
    if (model.products.length > 0 && !model.isLoading)
      _content = Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              //print('itemid: $index');
              ProductCard(model.products[index].productId, model.products),
          itemCount: model.products.length,
        ),
      );
    if (model.isLoading)
      _content = Center(
        child: CircularProgressIndicator(),
      );
    return RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        child: _content,
        onRefresh: () => model.fetchProductData());
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, Widget child, MainScopedModel model) {
      print('isLoading: ${model.isLoading}');
      return _productBuild(model, context);
    }); //getter products is called to retrieve data
  }
}
