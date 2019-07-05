import 'package:scoped_model/scoped_model.dart';
import '../models/Product.dart';
import '../models/User.dart';
import 'dart:convert'; //to convert data
import 'package:http/http.dart' as http; //for http

class ConnectedUserProduct extends Model {
  List<Product> _allProduct = [];
  int _selectedProductIndex;
  User authenticatedUser;
  bool _isLoading = true;

  Future<bool> addProduct(
      String title, String description, String price, String email) {
    Map<String, dynamic> productDetail = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
      'userEmail': email,
    }; // to post data to http we need Map object
    _isLoading = true;
    notifyListeners();
    return http
        .post('https://productlist-efaa0.firebaseio.com/Products',
            body: json.encode(productDetail))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      _isLoading = false;
      notifyListeners();
      final Map<String, dynamic> id = json.decode(response.body);
      print(id['name']);
      _allProduct.add(Product(
          productId: id['name'],
          title: productDetail['title'],
          description: productDetail['description'],
          price: productDetail['price'],
          image: productDetail['image'],
          userEmail: productDetail['userEmail'],
          isFavorite: false));
      return true;
    }); // we need to convert the Map object to json
    //notifyListeners();
  }

  Future<Null> fetchProductData() {
    /*_isLoading = true;
    notifyListeners();*/
    return http
        .get('https://productlist-efaa0.firebaseio.com/Products.json')
        .then((http.Response response) {
      //print(response.body);
      _isLoading = false;
      notifyListeners();

      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      final List<Product> productList = [];
      productListData.forEach((String id, dynamic productData) {
        final Product product = Product(
            productId: id,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail']);
        productList.add(product);
      });
      _allProduct = productList;
    });
  }
}

class UserScopeModel extends ConnectedUserProduct {
  void login(String email, password) {
    authenticatedUser =
        User(id: 'sbfvjhsbfjk', email: email, password: password);
  }
}

class ProductScopeModel extends ConnectedUserProduct {
  bool favoriteProduct = false;
  bool displayProductMode = false;

  List<Product> get products {
    //get all products
    if (displayProductMode)
      return _allProduct
          .where((Product product) => product.isFavorite)
          .toList();
    else
      return List.from(_allProduct);
  }

  void displayMode() {
    displayProductMode = !displayProductMode;
    notifyListeners();
  }

  bool get displayFavoriteProductMode {
    return displayProductMode;
  }

  void selectProduct(int index) {
    //to select product index while swiping product right to left
    _selectedProductIndex = index;
    notifyListeners();
  }

  Product get selectedProducts {
    if (_selectedProductIndex == null) {
      //if product is not selected then simply return
      return null;
    }
    return _allProduct[_selectedProductIndex];
  }

  void selectedFavoriteProduct(int index, Product p) {
    //to select product index while swiping product right to left
    //bool isCurrentlyFavorite = favoriteProduct;

    bool newFavorite = !favoriteProduct;
    Product product = Product(
        //create new instance for Product bcz Product is final so dont want to change directly the original product
        productId: p.productId,
        userEmail: p.userEmail,
        title: p.title,
        description: p.description,
        price: p.price,
        image: p.image,
        isFavorite: newFavorite);
    int a = _allProduct.indexOf(p);
    print('index: $a');
    _allProduct[a] = product;
    favoriteProduct = newFavorite;
    _selectedProductIndex = null;
    notifyListeners(); //to update the changes rebuild the widget
  }

  List<Product> get wishlistProduct {
    return _allProduct.where((Product product) => product.isFavorite).toList();
  }

  void deleteProduct() {
    //_product.remove(selectedProduct);
    _isLoading = true;
    String deletedProductID = selectedProducts.productId;
    _allProduct.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
    http
        .delete(
            'https://productlist-efaa0.firebaseio.com/Products/$deletedProductID.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> updateProduct(
      String title, String description, String price, Product selectedProduct) {
    Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
      'userEmail': selectedProduct.userEmail,
    };

    return http
        .put(
            'https://productlist-efaa0.firebaseio.com/Products/${selectedProduct.productId}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      _allProduct[_selectedProductIndex] = Product(
          productId: selectedProduct.productId,
          title: title,
          description: description,
          price: price,
          image:
              'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
          userEmail: selectedProduct.userEmail);
    });
  }

  void undoWishlist(int index, Product p) {
    Product product = Product(
        productId: wishlistProduct[index].productId,
        title: wishlistProduct[index].title,
        description: wishlistProduct[index].description,
        price: wishlistProduct[index].price,
        image: wishlistProduct[index].image,
        isFavorite: false,
        userEmail: wishlistProduct[index].userEmail);
    int a = _allProduct.indexOf(p);
    _allProduct[a] = product;
    //_selectedProductIndex=null;
    notifyListeners();
  }
}

class UtilityModel extends ConnectedUserProduct {
  bool get isLoading {
    return _isLoading;
  }
}
