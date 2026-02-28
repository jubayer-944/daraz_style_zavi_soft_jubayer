import 'package:daraz_style/features/home/domain/entities/product_entity.dart';
import 'package:daraz_style/features/home/domain/repositories/home_repository.dart';

class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<ProductEntity>> call(String category) {
    return _repository.getProductsByCategory(category);
  }
}

