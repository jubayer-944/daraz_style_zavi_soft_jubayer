import 'package:daraz_style/features/home/domain/entities/product_entity.dart';
import 'package:daraz_style/features/home/domain/entities/user_entity.dart';

abstract class HomeRepository {
  Future<String> login({
    required String username,
    required String password,
  });

  Future<UserEntity> getUserProfile();

  Future<List<ProductEntity>> getProducts();

  Future<List<ProductEntity>> getProductsByCategory(String category);
}

