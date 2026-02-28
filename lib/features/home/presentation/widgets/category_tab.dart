import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:daraz_style/features/home/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    super.key,
    required this.category,
    required this.onRefresh,
  });

  final String category;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: Obx(
        () {
          final isLoading =
              controller.isLoading && controller.productsFor(category).isEmpty;
          final error = controller.errorMessage;
          final products = controller.productsFor(category);

          if (isLoading) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: _scrollablePlaceholder(
                context,
                const Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (error != null && products.isEmpty) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: _scrollablePlaceholder(
                context,
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }

          if (products.isEmpty) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: _scrollablePlaceholder(
                context,
                const Center(child: Text('No products found')),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              key: PageStorageKey<String>(category),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  ProductTile(product: products[index]),
            ),
          );
        },
        ),
    );
  }
}

Widget _scrollablePlaceholder(BuildContext context, Widget child) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 200,
      ),
      child: child,
    ),
  );
}
