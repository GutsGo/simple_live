import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stitchtv_app/app/app_style.dart';
import 'package:stitchtv_app/widgets/navigation_sidebar.dart';

import 'indexed_controller.dart';

class IndexedPage extends GetView<IndexedController> {
  const IndexedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final isMedium = constraints.maxWidth > 600 && !isWide;
        final isMobilePortait = constraints.maxWidth <= 600;

        return Scaffold(
          body: Row(
            children: [
              // Sidebar for Desktop/Wide screens
              if (isWide &&
                  (Platform.isMacOS || Platform.isWindows || Platform.isLinux))
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(top: Platform.isMacOS ? 28.0 : 0),
                    child: NavigationSidebar(
                      items: controller.items,
                      selectedIndex: controller.index.value,
                      onDestinationSelected: controller.setIndex,
                    ),
                  ),
                ),

              // NavigationRail for Medium screens or non-desktop wide screens
              if (isMedium ||
                  (isWide &&
                      !(Platform.isMacOS ||
                          Platform.isWindows ||
                          Platform.isLinux)))
                Obx(
                  () => Container(
                    padding: EdgeInsets.only(top: Platform.isMacOS ? 28.0 : 0),
                    child: NavigationRail(
                      selectedIndex: controller.index.value,
                      onDestinationSelected: controller.setIndex,
                      labelType: NavigationRailLabelType.none,
                      destinations: controller.items
                          .map(
                            (item) => NavigationRailDestination(
                              icon: Icon(item.iconData),
                              selectedIcon: Icon(item.iconData),
                              label: Text(item.title),
                              padding: AppStyle.edgeInsetsV8,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

              Expanded(
                child: Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: (isWide || isMedium)
                            ? BorderSide(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withAlpha(30),
                                width: 1,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: IndexedStack(
                      index: controller.index.value,
                      children: controller.pages,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isMobilePortait
              ? Obx(
                  () => NavigationBar(
                    selectedIndex: controller.index.value,
                    onDestinationSelected: controller.setIndex,
                    height: 80,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysShow,
                    destinations: controller.items
                        .map(
                          (item) => NavigationDestination(
                            icon: Icon(item.iconData),
                            label: item.title,
                          ),
                        )
                        .toList(),
                  ),
                )
              : null,
        );
      },
    );
  }
}
