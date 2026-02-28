import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:daraz_style/features/home/presentation/widgets/header_content.dart';
import 'package:daraz_style/features/home/presentation/widgets/horizontal_product_images.dart';
import 'package:daraz_style/features/home/presentation/widgets/product_list_sliver.dart';
import 'package:daraz_style/features/home/presentation/widgets/search_bar.dart';
import 'package:daraz_style/features/home/presentation/widgets/tab_bar_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity > 300) {
            controller.goToTab(controller.tabController.index - 1);
          } else if (velocity < -300) {
            controller.goToTab(controller.tabController.index + 1);
          }
        },
        child: RefreshIndicator(
          onRefresh: controller.refreshAll,
          edgeOffset: kToolbarHeight,
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
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
                    child: const HomeSearchBar(),
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
                        .map((c) => Tab(text: c.toUpperCase()))
                        .toList(),
                  ),
                ),
              ),
              ProductListSliver(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
