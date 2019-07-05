import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class WishListProduct extends StatelessWidget {
  Widget WishList(MainScopedModel model, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(model.wishlistProduct[index].image),
          ),
          title: Text(
            model.wishlistProduct[index].title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          subtitle: Text('₹ ' + model.wishlistProduct[index].price),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>
                  model.undoWishlist(index, model.wishlistProduct[index])),
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
        body: model.wishlistProduct.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: model.wishlistProduct.length,
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
