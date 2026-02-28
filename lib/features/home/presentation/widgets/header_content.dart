import 'package:daraz_style/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderContent extends StatelessWidget {
  const HeaderContent({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = controller.user;
              return Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      (user?.name.isNotEmpty == true
                              ? user!.name[0]
                              : user?.username.isNotEmpty == true
                                  ? user!.username[0]
                                  : '?')
                          .toUpperCase(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name.isNotEmpty == true
                              ? user!.name
                              : user?.username ?? 'Guest',
                          style: theme.textTheme.titleMedium,
                        ),
                        if (user?.email.isNotEmpty == true)
                          Text(
                            user!.email,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
