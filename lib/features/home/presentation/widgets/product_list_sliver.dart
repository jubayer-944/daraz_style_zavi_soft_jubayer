import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:daraz_style/features/home/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListSliver extends StatelessWidget {
  const ProductListSliver({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.selectedTabIndex.value;
      final category = controller.categories[index];
      final isLoading =
          controller.isLoading && controller.productsFor(category).isEmpty;
      final error = controller.errorMessage;
      final products = controller.productsFor(category);

      if (isLoading) {
        return SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: MediaQuery.of(context).size.height - 350,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      }

      if (error != null && products.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: MediaQuery.of(context).size.height - 350,
            child: Center(
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
        return SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: MediaQuery.of(context).size.height - 350,
            child: const Center(child: Text('No products found')),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ProductTile(product: products[index]),
            ),
            childCount: products.length,
          ),
        ),
      );
    });
  }
}
