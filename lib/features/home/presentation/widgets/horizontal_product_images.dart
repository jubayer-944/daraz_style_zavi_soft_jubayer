import 'package:daraz_style/features/home/domain/entities/product_entity.dart';
import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalProductImages extends StatelessWidget {
  const HorizontalProductImages({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.allProducts;
      final isLoading = controller.isLoading;
      if (isLoading && products.isEmpty) {
        return Container(
          height: 100,
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }
      if (products.isEmpty) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No products',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildProductRoundImage(product),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductRoundImage(ProductEntity product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        width: 80,
        height: 80,
        child: Image.network(
          product.image,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          ),
        ),
      ),
    );
  }
}
