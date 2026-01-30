import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:simple_live_tv_app/app/app_focus_node.dart';
import 'package:simple_live_tv_app/app/app_style.dart';
import 'package:simple_live_tv_app/app/sites.dart';
import 'package:simple_live_tv_app/modules/hot_live/hot_live_controller.dart';
import 'package:simple_live_tv_app/routes/app_navigation.dart';
import 'package:simple_live_tv_app/widgets/app_scaffold.dart';
import 'package:simple_live_tv_app/widgets/apple_glass_container.dart';
import 'package:simple_live_tv_app/widgets/button/highlight_button.dart';
import 'package:simple_live_tv_app/widgets/card/live_room_card.dart';

class HotLivePage extends GetView<HotliveController> {
  const HotLivePage({super.key});

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
                  onTap: () {
                    Get.back();
                  },
                ),
                AppStyle.hGap32,
                Text(
                  "热门直播",
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
              () => MasonryGridView.count(
                padding: AppStyle.edgeInsetsH48.copyWith(bottom: 48.w),
                itemCount: controller.list.length,
                crossAxisCount: 4,
                crossAxisSpacing: 32.w,
                mainAxisSpacing: 32.w,
                controller: controller.scrollController,
                itemBuilder: (_, i) {
                  var item = controller.list[i];

                  if (i == 0) {
                    Future.delayed(Duration.zero, () {
                      if (controller.currentPage == 2) {
                        item.focusNode.requestFocus();
                      }
                    });
                  }
                  return LiveRoomCard(
                    cover: item.cover,
                    anchor: item.userName,
                    title: item.title,
                    focusNode: item.focusNode,
                    roomId: item.roomId,
                    online: item.online,
                    onTap: () {
                      AppNavigator.toLiveRoomDetail(
                        site: controller.site,
                        roomId: item.roomId,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
