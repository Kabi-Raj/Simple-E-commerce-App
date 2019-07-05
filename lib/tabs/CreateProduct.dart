import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class CreateProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateProductState();
  }
}

class _CreateProductState extends State<CreateProduct> {
  //String productName, productDesc, productPrice;

  final Map<String, dynamic> _formData = {
    'productTitle': null,
    'productDescription': null,
    'productPrice': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTextFieldProductName(Product selectedProduct) {
    return TextFormField(
      initialValue: selectedProduct == null ? '' : selectedProduct.title,
      scrollPadding: EdgeInsets.all(10.0),
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty || value.length < 4)
          return 'Title is empty or less than 5 characters';
      },
      onSaved: (String value) {
        //setState() is not required, bcz no need to rebuild widget
        _formData['productTitle'] = value;
      },
    );
  }

  Widget _buildTextFieldProductDescription(Product selectedProduct) {
    return TextFormField(
      initialValue: selectedProduct == null ? '' : selectedProduct.description,
      maxLines: 5,
      decoration: InputDecoration(labelText: 'Product Description'),
      validator: (String desc) {
        if (desc.isEmpty || desc.length < 10)
          return 'Description is empty or less than 10 characters';
      },
      onSaved: (String value) {
        _formData['productDescription'] = value;
      },
    );
  }

  Widget _buildTextFieldProductPrice(Product selectedProduct) {
    return TextFormField(
      initialValue: selectedProduct == null ? '' : selectedProduct.price,
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      validator: (String price) {
        if (price.isEmpty || !RegExp(r"^(0|[1-9]\d*)$").hasMatch(price))
          return 'Price is empty or not a number';
      },
      onSaved: (String value) {
        _formData['productPrice'] = value;
      },
    );
  }

  void _submitForm(
      Function addProduct,
      Function updateProduct,
      Product selectedProduct,
      Function setSelectedProduct,
      MainScopedModel model) {
    _formKey.currentState.save();

    if (!_formKey.currentState.validate()) {
      return;
    }
    if (selectedProduct == null)
      addProduct(_formData['productTitle'], _formData['productDescription'],
              _formData['productPrice'], model.authenticatedUser.email)
          .then((bool success) {
        if (success)
          Navigator.pushReplacementNamed(context, '/home')
              .then((_) => setSelectedProduct(null));
        else {
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
    else
      updateProduct(_formData['productTitle'], _formData['productDescription'],
              _formData['productPrice'], selectedProduct)
          .then((bool success) {
        Navigator.pushReplacementNamed(context, '/home')
            .then(setSelectedProduct(null));
      });
    /*Navigator.pushReplacementNamed(context, '/home').then((_) =>
        setSelectedProduct(
            null));*/ //after saving the form set the selected product index nto null
  }

  Widget _buildSubmitProduct(GlobalKey<FormState> _formKey) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return RaisedButton(
        elevation: 10.0,
        color: Theme.of(context).primaryColor,
        onPressed: () => _submitForm(model.addProduct, model.updateProduct,
            model.selectedProducts, model.selectProduct, model),
        child: Text('Save'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceOrientation = MediaQuery.of(context).orientation;
    final width = deviceOrientation == Orientation.landscape
        ? MediaQuery.of(context).size.width * 0.2
        : 10.0;

    Widget editProduct([Product selectedProduct]) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              FocusNode()); //closing keyboard when pressed outside Widget
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: width),
            children: <Widget>[
              _buildTextFieldProductName(selectedProduct),
              _buildTextFieldProductDescription(selectedProduct),
              _buildTextFieldProductPrice(selectedProduct),
              _buildSubmitProduct(_formKey),
            ],
          ),
        ),
      );
    }

    return ScopedModelDescendant<MainScopedModel>(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return model.selectedProducts == null
            ? editProduct()
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: editProduct(model.selectedProducts),
              );
      },
    );
  }
}
