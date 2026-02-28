import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:daraz_style/core/error/exceptions.dart';
import 'package:daraz_style/features/home/data/models/product_model.dart';
import 'package:daraz_style/features/home/data/models/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<String> login({
    required String username,
    required String password,
  });

  Future<UserModel> getUserProfile();

  Future<List<ProductModel>> getProducts();

  Future<List<ProductModel>> getProductsByCategory(String category);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._client);

  final Dio _client;

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/auth/login',
        data: <String, dynamic>{
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final data = response.data!;
        final token = data['token'] ?? data['access_token'];
        if (token is String && token.isNotEmpty) {
          return token;
        }
        throw ServerException('Invalid token response from server');
      }

      final msg = _extractErrorMessage(response.data) ??
          'Login failed (${response.statusCode})';
      throw ServerException(msg, statusCode: response.statusCode);
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e.response?.data) ??
          e.response?.statusMessage ??
          e.message ??
          'Network error during login';
      final statusCode = e.response?.statusCode;
      debugPrint(
          '[RemoteDataSource] Login failed: $msg (status: $statusCode, type: ${e.type})');
      throw ServerException(msg, statusCode: statusCode);
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return (data['message'] ?? data['error'] ?? data['msg'])?.toString();
    }
    return null;
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/users/1');

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data!);
      }

      throw ServerException(
        'Failed to load user profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = e.message ?? 'Network error while loading user';
      final statusCode = e.response?.statusCode;
      debugPrint('[RemoteDataSource] Get user failed: $message (status: $statusCode, type: ${e.type})');
      throw ServerException(message, statusCode: statusCode);
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _client.get<List<dynamic>>('/products');

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .whereType<Map<String, dynamic>>()
            .map(ProductModel.fromJson)
            .toList();
      }

      throw ServerException(
        'Failed to load products',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = e.message ?? 'Network error while loading products';
      final statusCode = e.response?.statusCode;
      debugPrint('[RemoteDataSource] Get products failed: $message (status: $statusCode, type: ${e.type})');
      throw ServerException(message, statusCode: statusCode);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final encoded = Uri.encodeComponent(category);
      final response = await _client.get<List<dynamic>>(
        '/products/category/$encoded',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .whereType<Map<String, dynamic>>()
            .map(ProductModel.fromJson)
            .toList();
      }

      throw ServerException(
        'Failed to load products',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = e.message ?? 'Network error while loading products';
      final statusCode = e.response?.statusCode;
      debugPrint('[RemoteDataSource] Get products ($category) failed: $message (status: $statusCode, type: ${e.type})');
      throw ServerException(message, statusCode: statusCode);
    }
  }
}

