import 'package:daraz_style/features/home/domain/entities/user_entity.dart';
import 'package:daraz_style/features/home/domain/repositories/home_repository.dart';

class GetUserUseCase {
  GetUserUseCase(this._repository);

  final HomeRepository _repository;

  Future<UserEntity> call() {
    return _repository.getUserProfile();
  }
}

