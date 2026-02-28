import 'package:daraz_style/core/error/exceptions.dart';
import 'package:daraz_style/features/home/data/datasources/home_remote_data_source.dart';
import 'package:daraz_style/features/home/domain/entities/product_entity.dart';
import 'package:daraz_style/features/home/domain/entities/user_entity.dart';
import 'package:daraz_style/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(
        username: username,
        password: password,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error during login: $e');
    }
  }

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      return await _remoteDataSource.getUserProfile();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error while loading user: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      return await _remoteDataSource.getProducts();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error while loading products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    try {
      return await _remoteDataSource.getProductsByCategory(category);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error while loading products: $e');
    }
  }
}

