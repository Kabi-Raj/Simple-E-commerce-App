import 'package:scoped_model/scoped_model.dart';
import '../models/Product.dart';
import '../models/User.dart';
import 'dart:convert'; //to convert data
import 'package:http/http.dart' as http; //for http
import '../models/Auth.dart';

class ConnectedUserProduct extends Model {
  List<Product> _allProduct = [];
  String _selectedProductID;
  User authenticatedUser;
  bool _isLoading = false;
  http.Response response;
  Map<String, dynamic> errorCode;
}

class UserScopeModel extends ConnectedUserProduct {
  Future<Map<String, dynamic>> authUser(String email, String password,
      [Auth authMode = Auth.Login]) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> _authValue = {'email': email, 'password': password};
    if (authMode == Auth.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDhLSjiKNhqMrRws4d1MpErLcs0Gf85T1M',
          body: json.encode(_authValue));
    }

    if (authMode == Auth.Signup) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key= AIzaSyDhLSjiKNhqMrRws4d1MpErLcs0Gf85T1M',
          body: json.encode(_authValue),
          headers: {'Content-Type': 'application/json'});
    }

    errorCode = json.decode(response.body);
    print(errorCode['localId']);
    /*print('error: ');
    print(errorCode['email']);
    print(response.body);
    print(errorCode['error']['message']);
    print(errorCode['error']['message']);*/

    authenticatedUser = User(
        id: errorCode['localId'], email: email, token: errorCode['idToken']);

    if (response.statusCode == 200 || response.statusCode == 201) {
      _isLoading = false;
      notifyListeners();
      return {'success': true, 'message': 'Authentication successful'};
    }

    if (errorCode['error']['message'] == 'EMAIL_NOT_FOUND') {
      _isLoading = false;
      notifyListeners();
      return {'success': 'EMAIL_NOT_FOUND', 'message': 'This email not found'};
    }
    if (errorCode['error']['message'] == 'INVALID_PASSWORD') {
      _isLoading = false;
      notifyListeners();
      return {'success': 'INVALID_PASSWORD', 'message': 'Invalid password'};
    }
    if (errorCode['error']['message'] == 'USER_DISABLED') {
      _isLoading = false;
      notifyListeners();
      return {'success': 'USER_DISABLED', 'message': 'Your email is disabled'};
    }
    if (errorCode['error']['message'] == 'EMAIL_EXISTS') {
      _isLoading = false;
      notifyListeners();
      return {
        'success': 'EMAIL_EXISTS',
        'message': 'This email already exists'
      };
    }
    return {};
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

  void selectProduct(String productID) {
    //to select product index while swiping product right to left
    _selectedProductID = productID;
    notifyListeners();
  }

  Product get selectedProducts {
    if (_selectedProductID == null) {
      //if product is not selected then simply return
      return null;
    }

    return products.firstWhere((Product product) {
      return product.productId == _selectedProductID;
    });
    //return _allProduct[_selectedProductIndex];
  }

  int get selectedProductIndex {
    return products.indexWhere((Product product) {
      return product.productId == _selectedProductID;
    });
  }

  void selectedFavoriteProduct(Product p) {
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
    _selectedProductID = null;
    notifyListeners(); //to update the changes rebuild the widget
  }

  Future<bool> addProduct(
      String title, String description, String price, String email) async {
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
    try {
      final http.Response response = await http.post(
          'https://productlist-efaa0.firebaseio.com/Products.json',
          body: json.encode(productDetail));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      notifyListeners();
      final Map<String, dynamic> id = json
          .decode(response.body); // we need to convert the Map object to json
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
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchProductData() async {
    _isLoading = true;
    notifyListeners();
    response = await http
        .get('https://productlist-efaa0.firebaseio.com/Products.json?')
        .then((http.Response response) {
      //print(response.body);
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      print(authenticatedUser.token);
      _isLoading = false;
      notifyListeners();

      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        //return;
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
      return response;
    });

    //return response;
  }

  Future<bool> deleteProduct() {
    //_product.remove(selectedProduct);
    _isLoading = true;
    notifyListeners();
    String deletedProductID = selectedProducts.productId;

    _allProduct.removeAt(selectedProductIndex);
    _selectedProductID = null;
    notifyListeners();
    return http
        .delete(
            'https://productlist-efaa0.firebaseio.com/Products/$deletedProductID.json')
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
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
      Product product = Product(
          productId: selectedProduct.productId,
          title: title,
          description: description,
          price: price,
          image:
              'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
          userEmail: selectedProduct.userEmail);
      _allProduct[selectedProductIndex] = product;
      selectProduct(null);
      notifyListeners();
    });
  }

  void removeWishList(int index, Product p) {
    print(wishListProduct[index].title);
    Product product = Product(
        productId: wishListProduct[index].productId,
        title: wishListProduct[index].title,
        description: wishListProduct[index].description,
        price: wishListProduct[index].price,
        image: wishListProduct[index].image,
        isFavorite: false,
        userEmail: wishListProduct[index].userEmail);
    //int a = _allProduct.indexOf(p);
    _allProduct[index] = product;
    _selectedProductID = null;
    notifyListeners();
  }

  List<Product> get wishListProduct {
    return _allProduct.where((Product product) => product.isFavorite).toList();
  }
}

/*void fetchProductId() async {
  http.Response response =
      await http.get('https://productlist-efaa0.firebaseio.com/Products.json');

  if (response.statusCode == 200 && response.statusCode == 201) {
    final List<Map<String,dynamic>> productlist=json.decode(response.body);
  }
}*/

class UtilityModel extends ConnectedUserProduct {
  bool get isLoading {
    return _isLoading;
  }
}
