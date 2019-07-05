import 'package:flutter/material.dart';
import './ProductsList.dart';
import '../drawers/ManageProductDrawer.dart';
import '../scopedModel/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  final MainScopedModel model;

  HomePage(this.model);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return Scaffold(
          backgroundColor: Colors.blueGrey,
          drawer: ManageProductDrawer(),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: model.displayProductMode ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    model.displayMode();
                  }),
            ],
            title: Text('Product List'),
            elevation: 10.0,
          ),
          body: ProductsList(model),
        );
      },
    );
  }
}
