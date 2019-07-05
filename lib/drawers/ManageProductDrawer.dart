import 'package:flutter/material.dart';
import '../screens/ProductManager.dart';
import '../screens/WishListProducts.dart';

class ManageProductDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.5), BlendMode.dstATop),
                    image: AssetImage('assets/background.jpg'))),
            alignment: Alignment.center,
            child: Text(
              'choose an option',
              style: TextStyle(fontSize: 30.0),
            ),
            height: 120.0,
            //color: Colors.blue,
            width: 500.0,
          ),
          /*AppBar(
            title: Text('Choose an option'),
            automaticallyImplyLeading: false,
          ),*/
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'product manager');
              }),
          ListTile(
              leading: Icon(Icons.favorite),
              title: Text('My wishlist'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishListProduct()));
              })
        ],
      ),
    );
  }
}
