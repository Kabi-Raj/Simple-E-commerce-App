import 'package:scoped_model/scoped_model.dart';
import '../models/Product.dart';
import '../models/User.dart';

class ConnectedUserProduct extends Model {
  List<Product> _allProduct = [];
  int _selectedProductIndex;
  User authenticatedUser;

  void addProduct(Product product) {
    _allProduct.add(product);
    notifyListeners();
  }
}

class UserScopeModel extends ConnectedUserProduct {

  void login(String email, password) {
    authenticatedUser = User(id: 'sbfvjhsbfjk', email: email, password: password);
  }
}

class ProductScopeModel extends ConnectedUserProduct {
  bool favoriteProduct = false;
  bool displayProductMode = false;

  List<Product> get products {
    //get all products
    if (displayProductMode)
      return _allProduct.where((Product product) => product.isFavorite).toList();
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
    _allProduct.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _allProduct[_selectedProductIndex] = product;
    notifyListeners();
  }

  void undoWishlist(int index, Product p) {
    Product product = Product(
        title: wishlistProduct[index].title,
        description: wishlistProduct[index].description,
        price: wishlistProduct[index].price,
        image: wishlistProduct[index].image,
        isFavorite: false);
    int a = _allProduct.indexOf(p);
    _allProduct[a] = product;
    //_selectedProductIndex=null;
    notifyListeners();
  }
}

