import 'package:flutter/material.dart';
import './CreateProduct.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class MyProduct extends StatefulWidget {
  final MainScopedModel model;

  MyProduct(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MyProductState();
  }
}

class _MyProductState extends State<MyProduct> {
  @override
  initState() {
    widget.model.fetchProductData();
    super.initState();
  }

  Widget _buildEditButton(
      BuildContext context, MainScopedModel model, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        //get selected product not selected product index
        // but it doesn't work bcz first need to know selected product index
        //then only selectedProductIndex can be checked in selectedProducts getter
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateProduct(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, Widget child, MainScopedModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.products[index].title),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteProduct().then((bool success) {
                    if (!success) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Something went wrong'),
                              content: Text('Try after sometime'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Okay'))
                              ],
                            );
                          });
                    }
                  });
                }
              },
              child: model.isLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(model.products[index].image),
                            ),
                            title: Text(
                              model.products[index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '₹ ' + model.products[index].price,
                            ),
                            trailing: _buildEditButton(context, model, index),
                          ),
                        ),
                        Divider(height: 2.0),
                      ],
                    ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
