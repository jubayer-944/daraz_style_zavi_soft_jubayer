import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:daraz_style/features/home/presentation/widgets/category_tab.dart';
import 'package:daraz_style/features/home/presentation/widgets/header_content.dart';
import 'package:daraz_style/features/home/presentation/widgets/horizontal_product_images.dart';
import 'package:daraz_style/features/home/presentation/widgets/tab_bar_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 150,
              titleSpacing: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: HeaderContent(controller: controller),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: const _SearchBar(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalProductImages(controller: controller),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarHeaderDelegate(
                TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.zero,
                  tabs: controller.categories
                      .map(
                        (c) => Tab(
                          text: c.toUpperCase(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: controller.tabController,
          children: controller.categories
              .map((category) => CategoryTab(
                    category: category,
                    onRefresh: controller.refreshAll,
                  ))
              .toList(),
        ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search products',
        prefixIcon: const Icon(Icons.search, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
