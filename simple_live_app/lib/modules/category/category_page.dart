import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/modules/category/category_controller.dart';
import 'package:simple_live_app/modules/category/category_list_view.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: Platform.isMacOS,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          titleSpacing: 8,
          title: TabBar(
            controller: controller.tabController,
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            tabs: Sites.supportSites
                .map(
                  (e) => Tab(
                    child: Row(
                      children: [
                        Image.asset(
                          e.logo,
                          width: 24,
                        ),
                        AppStyle.hGap8,
                        Text(e.name),
                      ],
                    ),
                  ),
                )
                .toList(),
            labelPadding: AppStyle.edgeInsetsH16,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: Sites.supportSites
              .map(
                (e) => CategoryListView(
                  e.id,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
