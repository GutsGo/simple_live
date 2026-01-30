import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_live_tv_app/routes/app_navigation.dart';
import 'package:simple_live_tv_app/widgets/highlight_widget.dart';
import 'package:simple_live_tv_app/widgets/net_image.dart';
import 'package:get/get.dart';
import 'package:simple_live_tv_app/app/app_focus_node.dart';
import 'package:simple_live_tv_app/app/app_style.dart';
import 'package:simple_live_tv_app/app/sites.dart';
import 'package:simple_live_tv_app/modules/category/category_controller.dart';
import 'package:simple_live_tv_app/widgets/apple_glass_container.dart';
import 'package:simple_live_tv_app/widgets/app_scaffold.dart';
import 'package:simple_live_tv_app/widgets/button/highlight_button.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          AppleGlassContainer(
            borderRadius: BorderRadius.zero,
            padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 48.w),
            blur: 30,
            color: Colors.black.withOpacity(0.3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HighlightButton(
                  focusNode: AppFocusNode(),
                  iconData: Icons.arrow_back_rounded,
                  text: "返回",
                  autofocus: true,
                  onTap: () {
                    Get.back();
                  },
                ),
                AppStyle.hGap32,
                Text(
                  "直播类目",
                  style: AppStyle.titleStyleWhite.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Visibility(
                    visible: controller.loadding.value,
                    child: SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppStyle.vGap24,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Row(
              children: Sites.supportSites
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.only(right: 24.w),
                      child: Obx(
                        () => HighlightButton(
                          icon: Image.asset(
                            e.logo,
                            width: 36.w,
                            height: 36.w,
                          ),
                          text: e.name,
                          selected: controller.siteId.value == e.id,
                          focusNode: AppFocusNode(),
                          onTap: () {
                            controller.setSite(e.id);
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          AppStyle.vGap24,
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: AppStyle.edgeInsetsH48.copyWith(bottom: 48.w),
                itemCount: controller.list.length,
                controller: controller.scrollController,
                itemBuilder: (_, i) {
                  var item = controller.list[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 48.w, bottom: 24.w),
                        child: Text(
                          item.name,
                          style: AppStyle.titleStyleWhite.copyWith(
                            fontSize: 32.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Wrap(
                          spacing: 24.w,
                          runSpacing: 24.w,
                          children: item.showAll.value
                              ? (item.childrenExt
                                  .map(
                                    (e) => buildSubCategory(e),
                                  )
                                  .toList())
                              : (item.take15
                                  .map(
                                    (e) => buildSubCategory(e),
                                  )
                                  .toList()
                                ..add(buildShowMore(item))),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubCategory(LiveSubCategoryExt item) {
    return SizedBox(
      width: 160.w,
      child: HighlightWidget(
        focusNode: item.focusNode,
        onTap: () {
          AppNavigator.toCategoryDetail(site: controller.site, category: item);
        },
        borderRadius: AppStyle.radius20,
        child: Container(
          padding: AppStyle.edgeInsetsA16,
          decoration: BoxDecoration(
            color: AppColors.appleGray,
            borderRadius: AppStyle.radius20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (item.pic != null && item.pic!.isNotEmpty)
                  ? NetImage(
                      item.pic ?? "",
                      width: 56.w,
                      height: 56.w,
                      borderRadius: 12.w,
                      cacheWidth: 100,
                    )
                  : Image.asset(
                      "assets/images/${controller.site.id}.png",
                      width: 56.w,
                      height: 56.w,
                    ),
              AppStyle.vGap12,
              Text(
                item.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppStyle.textStyleWhite.copyWith(
                  fontSize: 22.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShowMore(AppLiveCategory item) {
    return SizedBox(
      width: 160.w,
      child: HighlightWidget(
        focusNode: item.moreFocusNode,
        onTap: () {
          item.showAll.value = true;
        },
        borderRadius: AppStyle.radius20,
        child: Container(
          padding: AppStyle.edgeInsetsA16,
          height: 140.w, // Fixed height to match other items approximately
          decoration: BoxDecoration(
            color: AppColors.appleGray.withOpacity(0.5),
            borderRadius: AppStyle.radius20,
          ),
          child: Center(
            child: Text(
              "更多",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppStyle.textStyleWhite.copyWith(
                fontSize: 24.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
