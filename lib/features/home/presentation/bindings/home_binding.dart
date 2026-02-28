import 'package:daraz_style/core/network/api_client.dart';
import 'package:daraz_style/core/storage/token_storage.dart';
import 'package:daraz_style/features/home/data/datasources/home_remote_data_source.dart';
import 'package:daraz_style/features/home/data/repositories/home_repository_impl.dart';
import 'package:daraz_style/features/home/domain/repositories/home_repository.dart';
import 'package:daraz_style/features/home/domain/usecases/get_products_usecase.dart';
import 'package:daraz_style/features/home/domain/usecases/get_user_usecase.dart';
import 'package:daraz_style/features/home/domain/usecases/login_usecase.dart';
import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Storage
    Get.lazyPut<TokenStorage>(() => TokenStorage());

    // Data sources
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(ApiClient.dio),
    );

    // Repositories
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find<HomeRemoteDataSource>()),
    );

    // Use cases
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<HomeRepository>()),
    );
    Get.lazyPut<GetUserUseCase>(
      () => GetUserUseCase(Get.find<HomeRepository>()),
    );
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find<HomeRepository>()),
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        loginUseCase: Get.find<LoginUseCase>(),
        getUserUseCase: Get.find<GetUserUseCase>(),
        getProductsUseCase: Get.find<GetProductsUseCase>(),
        tokenStorage: Get.find<TokenStorage>(),
      ),
    );
  }
}

