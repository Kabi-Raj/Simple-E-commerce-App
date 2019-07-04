import 'package:scoped_model/scoped_model.dart';
import './ConnectedUserProduct.dart';

class MainScopedModel extends Model
    with ConnectedUserProduct, ProductScopeModel, UserScopeModel {}
