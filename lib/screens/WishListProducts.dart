import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class WishListProduct extends StatelessWidget {
  Widget WishList(MainScopedModel model, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(model.wishListProduct[index].image),
          ),
          title: Text(
            model.wishListProduct[index].title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          subtitle: Text('₹ ' + model.wishListProduct[index].price),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>
                  model.removeWishList(index, model.wishListProduct[index])),
        ),
        Divider(
          height: 2.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('WishList products'),
        ),
        body: model.wishListProduct.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: model.wishListProduct.length,
                itemBuilder: (context, int index) => WishList(model, index))
            : Container(
                child: Text(
                  'Empty wishlist',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
      );
    }), onWillPop: () {
      Navigator.pop(context, true);
      return Future.value(false);
    });
  }
}
