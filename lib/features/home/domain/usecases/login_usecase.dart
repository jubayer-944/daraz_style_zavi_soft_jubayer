import 'package:daraz_style/features/home/domain/repositories/home_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final HomeRepository _repository;

  Future<String> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}

