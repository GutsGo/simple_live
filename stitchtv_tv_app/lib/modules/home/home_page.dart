import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stitchtv_tv_app/app/app_focus_node.dart';
import 'package:stitchtv_tv_app/app/app_style.dart';
import 'package:stitchtv_tv_app/app/utils.dart';
import 'package:stitchtv_tv_app/modules/home/home_controller.dart';
import 'package:stitchtv_tv_app/services/follow_user_service.dart';
import 'package:stitchtv_tv_app/widgets/app_scaffold.dart';
import 'package:stitchtv_tv_app/widgets/button/highlight_button.dart';
import 'package:stitchtv_tv_app/widgets/button/highlight_list_tile.dart';
import 'package:stitchtv_tv_app/widgets/card/anchor_card.dart';
import 'package:stitchtv_tv_app/widgets/button/home_big_button.dart';
import 'package:stitchtv_tv_app/widgets/apple_glass_container.dart';
import 'package:stitchtv_tv_app/widgets/net_image.dart';
import 'package:stitchtv_tv_app/widgets/status/app_empty_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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
                Text(
                  "乱炖直播",
                  style: AppStyle.titleStyleWhite.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Text(
                    controller.datetime.value,
                    style: AppStyle.titleStyleWhite.copyWith(
                      fontSize: 32.w,
                      color: Colors.white70,
                    ),
                  ),
                ),
                AppStyle.hGap32,
                HighlightButton(
                  focusNode: AppFocusNode(),
                  iconData: Icons.settings_outlined,
                  text: "设置",
                  onTap: () {
                    controller.toSettings();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: AppStyle.edgeInsetsV48,
              children: [
                Padding(
                  padding: AppStyle.edgeInsetsH48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: HomeBigButton(
                          autofocus: true,
                          focusNode: AppFocusNode(),
                          text: "热门",
                          iconData: Remix.fire_line,
                          onTap: controller.toHotLive,
                        ),
                      ),
                      AppStyle.hGap32,
                      Expanded(
                        child: HomeBigButton(
                          focusNode: AppFocusNode(),
                          text: "类目",
                          iconData: Remix.apps_line,
                          onTap: controller.toCategory,
                        ),
                      ),
                      AppStyle.hGap32,
                      Expanded(
                        child: HomeBigButton(
                          focusNode: AppFocusNode(),
                          text: "搜索",
                          iconData: Remix.search_2_line,
                          onTap: showSearchDialog,
                        ),
                      ),
                      AppStyle.hGap32,
                      Expanded(
                        child: HomeBigButton(
                          focusNode: AppFocusNode(),
                          text: "记录",
                          iconData: Icons.history_rounded,
                          onTap: controller.toHistory,
                        ),
                      ),
                      AppStyle.hGap32,
                      Expanded(
                        child: HomeBigButton(
                          focusNode: AppFocusNode(),
                          text: "同步",
                          iconData: Icons.sync_rounded,
                          onTap: controller.toSync,
                        ),
                      ),
                    ],
                  ),
                ),
                AppStyle.vGap48,
                Padding(
                  padding: AppStyle.edgeInsetsH48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.pinkAccent,
                        size: 40.w,
                      ),
                      AppStyle.hGap16,
                      Expanded(
                        child: Text(
                          "我的关注",
                          style: AppStyle.titleStyleWhite.copyWith(
                            fontSize: 32.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: FollowUserService.instance.updating.value,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32.w,
                                height: 32.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3.w,
                                ),
                              ),
                              AppStyle.hGap12,
                              Text(
                                "更新中",
                                style: AppStyle.subTextStyleWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppStyle.hGap16,
                      HighlightButton(
                        focusNode: AppFocusNode(),
                        iconData: Icons.edit_note_rounded,
                        text: "管理",
                        onTap: showManageDialog,
                      ),
                      AppStyle.hGap16,
                      HighlightButton(
                        focusNode: AppFocusNode(),
                        iconData: Icons.refresh_rounded,
                        text: "刷新",
                        onTap: () {
                          FollowUserService.instance.refreshData();
                        },
                      ),
                    ],
                  ),
                ),
                AppStyle.vGap32,
                Obx(
                  () => MasonryGridView.count(
                    padding: AppStyle.edgeInsetsH48,
                    itemCount: FollowUserService.instance.list.length,
                    crossAxisCount: 3,
                    crossAxisSpacing: 32.w,
                    mainAxisSpacing: 32.w,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      var item = FollowUserService.instance.list[i];
                      return Obx(
                        () => AnchorCard(
                          face: item.face,
                          name: item.userName,
                          siteId: item.siteId,
                          liveStatus: item.liveStatus.value,
                          roomId: item.roomId,
                        ),
                      );
                    },
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: FollowUserService.instance.list.isEmpty,
                    child: AppleGlassContainer(
                      padding: AppStyle.edgeInsetsA48,
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                            'assets/lotties/empty.json',
                            width: 120.w,
                            height: 120.w,
                            repeat: false,
                          ),
                          AppStyle.vGap24,
                          Text(
                            "暂无关注的主播\n你可以从手机或电脑端同步关注列表",
                            textAlign: TextAlign.center,
                            style: AppStyle.textStyleWhite.copyWith(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          AppStyle.vGap32,
                          HighlightButton(
                            focusNode: AppFocusNode(),
                            iconData: Icons.sync_rounded,
                            text: "去同步数据",
                            onTap: () {
                              controller.toSync();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showManageDialog() {
    Utils.showSystemRightDialog(
      //useSystem: true,
      width: 700.w,
      child: Column(
        children: [
          AppStyle.vGap24,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppStyle.hGap48,
              HighlightButton(
                focusNode: AppFocusNode(),
                iconData: Icons.arrow_back,
                text: "返回",
                onTap: () {
                  //Utils.hideRightDialog();
                  Get.back();
                },
              ),
              AppStyle.hGap32,
              Text(
                "关注管理",
                style: AppStyle.titleStyleWhite.copyWith(
                  fontSize: 36.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppStyle.hGap24,
              const Spacer(),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () => ListView.separated(
                    itemCount: FollowUserService.instance.list.length,
                    separatorBuilder: (_, __) => AppStyle.vGap24,
                    padding: AppStyle.edgeInsetsA40,
                    itemBuilder: (_, i) {
                      var item = FollowUserService.instance.list[i];
                      var foucsNode = AppFocusNode();
                      return HighlightListTile(
                        autofocus: i == 0,
                        leading: NetImage(
                          item.face,
                          width: 64.w,
                          height: 64.w,
                          borderRadius: 64.w,
                        ),
                        title: item.userName,
                        focusNode: foucsNode,
                        trailing: Obx(
                          () => Icon(
                            Icons.delete_outline_outlined,
                            size: 40.w,
                            color: foucsNode.isFoucsed.value
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        onTap: () {
                          FollowUserService.instance
                              .removeItem(item, refresh: false);
                        },
                      );
                    },
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: FollowUserService.instance.list.isEmpty,
                    child: const AppEmptyWidget(
                      text: "关注列表为空，快去关注一些主播吧",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSearchDialog() {
    var textController = TextEditingController();
    var mode = 0.obs;
    var roomFocusNode = AppFocusNode()..isFoucsed.value = true;
    var anchorFocusNode = AppFocusNode();
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        backgroundColor: Get.theme.cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyle.radius16,
        ),
        contentPadding: AppStyle.edgeInsetsA48,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => HighlightButton(
                    text: "直播间",
                    iconData: Icons.live_tv,
                    selected: mode.value == 0,
                    focusNode: roomFocusNode,
                    autofocus: roomFocusNode.isFoucsed.value,
                    onTap: () {
                      mode.value = 0;
                    },
                  ),
                ),
                AppStyle.hGap40,
                Obx(
                  () => HighlightButton(
                    text: "主播",
                    selected: mode.value == 1,
                    iconData: Icons.person,
                    focusNode: anchorFocusNode,
                    autofocus: anchorFocusNode.isFoucsed.value,
                    onTap: () {
                      mode.value = 1;
                    },
                  ),
                ),
              ],
            ),
            AppStyle.vGap48,
            SizedBox(
              width: 700.w,
              child: TextField(
                controller: textController,
                style: AppStyle.textStyleWhite,
                textInputAction: TextInputAction.search,
                onSubmitted: (e) {
                  Get.back();
                  if (e.isEmpty) {
                    return;
                  }
                  if (mode.value == 0) {
                    controller.toSearchRoom(textController.text);
                  } else {
                    controller.toSearchAnchor(textController.text);
                  }
                },
                decoration: InputDecoration(
                  hintText: mode.value == 0 ? "点击输入关键字搜索" : "点击主播昵称搜索",
                  hintStyle: AppStyle.textStyleWhite,
                  border: OutlineInputBorder(
                    borderRadius: AppStyle.radius16,
                    borderSide: BorderSide(width: 4.w),
                  ),
                  filled: true,
                  isDense: true,
                  fillColor: Get.theme.primaryColor,
                  contentPadding: AppStyle.edgeInsetsA32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
