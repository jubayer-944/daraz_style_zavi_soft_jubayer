import 'package:daraz_style/core/error/exceptions.dart';
import 'package:daraz_style/core/storage/token_storage.dart';
import 'package:daraz_style/features/home/domain/entities/product_entity.dart';
import 'package:daraz_style/features/home/domain/entities/user_entity.dart';
import 'package:daraz_style/features/home/domain/usecases/get_products_usecase.dart';
import 'package:daraz_style/features/home/domain/usecases/get_user_usecase.dart';
import 'package:daraz_style/features/home/domain/usecases/login_usecase.dart';
import 'package:daraz_style/features/home/presentation/widgets/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController({
    required LoginUseCase loginUseCase,
    required GetUserUseCase getUserUseCase,
    required GetProductsUseCase getProductsUseCase,
    required TokenStorage tokenStorage,
  })  : _loginUseCase = loginUseCase,
        _getUserUseCase = getUserUseCase,
        _getProductsUseCase = getProductsUseCase,
        _tokenStorage = tokenStorage;

  final LoginUseCase _loginUseCase;
  final GetUserUseCase _getUserUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final TokenStorage _tokenStorage;

  late final TabController tabController;
  late final ScrollController scrollController;
  final selectedTabIndex = 0.obs;
  final _scrollOffsets = <int, double>{};
  int _lastTabIndex = 0;

  final categories = <String>[
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  final _isLoading = false.obs;
  final _isRefreshing = false.obs;
  final _errorMessage = RxnString();

  final _user = Rxn<UserEntity>();
  final _token = RxnString();

  final _allProducts = <ProductEntity>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String? get errorMessage => _errorMessage.value;
  UserEntity? get user => _user.value;
  String? get token => _token.value;

  List<ProductEntity> get allProducts => _allProducts;

  List<ProductEntity> productsFor(String category) =>
      _allProducts
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    scrollController = ScrollController();
    tabController.addListener(_onTabChanged);
    _checkLoginAndLoad();
  }

  void _onTabChanged() {
    selectedTabIndex.value = tabController.index;
    if (!tabController.indexIsChanging && scrollController.hasClients) {
      final newIndex = tabController.index;
      _scrollOffsets[_lastTabIndex] = scrollController.offset;
      final saved = _scrollOffsets[newIndex] ?? 0;
      _lastTabIndex = newIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            saved.clamp(0.0, scrollController.position.maxScrollExtent),
          );
        }
      });
    }
  }

  Future<void> _checkLoginAndLoad() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      _token.value = token;
      await _initialLoad();
    } else {
      // Delay until overlay is ready (Get.overlayContext is null during init).
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) _showLoginDialog();
      });
    }
  }

  Future<void> _showLoginDialog() async {
    final result = await Get.dialog<bool>(
      LoginDialog(
        onLogin: _loginWithCredentials,
      ),
      barrierDismissible: false,
    );
    if (result == true && isClosed == false) {
      await _initialLoad();
    }
  }

  Future<void> _loginWithCredentials(String username, String password) async {
    final token = await _loginUseCase(username: username, password: password);
    _token.value = token;
    await _tokenStorage.saveToken(token);
  }

  Future<void> _initialLoad() async {
    _isLoading.value = true;
    _errorMessage.value = null;
    try {
      await _fetchUser();
      await _fetchProducts();
    } on ServerException catch (e) {
      debugPrint(
          '[HomeController] Initial load error: ${e.message} (status: ${e.statusCode})');
      _errorMessage.value = e.message;
    } catch (e, stackTrace) {
      debugPrint('[HomeController] Initial load unexpected error: $e');
      debugPrint(stackTrace.toString());
      _errorMessage.value = 'Unexpected error: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    debugPrint('[HomeController] refreshAll (root pull-to-refresh) called');
    _isRefreshing.value = true;
    _errorMessage.value = null;
    try {
      await _fetchUser();
      await _fetchProducts();
    } on ServerException catch (e) {
      debugPrint(
          '[HomeController] Refresh error: ${e.message} (status: ${e.statusCode})');
      _errorMessage.value = e.message;
    } catch (e, stackTrace) {
      debugPrint('[HomeController] Refresh unexpected error: $e');
      debugPrint(stackTrace.toString());
      _errorMessage.value = 'Unexpected error: $e';
    } finally {
      _isRefreshing.value = false;
    }
  }

  Future<void> _fetchUser() async {
    final fetchedUser = await _getUserUseCase();
    _user.value = fetchedUser;
    debugPrint('[HomeController] User API response: $fetchedUser');
  }

  Future<void> _fetchProducts() async {
    final products = await _getProductsUseCase();
    _allProducts.value = products;
    debugPrint('[HomeController] Products API response: ${products.length} items');
    for (final p in products.take(3)) {
      debugPrint('  - ${p.title} (\$${p.price})');
    }
    if (products.length > 3) {
      debugPrint('  ... and ${products.length - 3} more');
    }
  }

  void goToTab(int index) {
    tabController.animateTo(index.clamp(0, categories.length - 1));
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

