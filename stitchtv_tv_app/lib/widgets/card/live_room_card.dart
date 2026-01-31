import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stitchtv_tv_app/app/app_focus_node.dart';
import 'package:stitchtv_tv_app/app/app_style.dart';
import 'package:stitchtv_tv_app/app/utils.dart';
import 'package:stitchtv_tv_app/widgets/highlight_widget.dart';
import 'package:stitchtv_tv_app/widgets/net_image.dart';
import 'package:marquee/marquee.dart';

class LiveRoomCard extends StatelessWidget {
  final String cover;
  final String title;
  final String anchor;
  final String roomId;
  final int online;
  final bool autofocus;
  final AppFocusNode focusNode;
  final Function()? onTap;
  const LiveRoomCard({
    required this.cover,
    required this.title,
    required this.anchor,
    required this.roomId,
    required this.focusNode,
    required this.online,
    this.autofocus = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HighlightWidget(
      focusNode: focusNode,
      onTap: onTap,
      borderRadius: AppStyle.radius20,
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.appleGray,
            borderRadius: AppStyle.radius20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.w),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: NetImage(
                        cover,
                        cacheWidth: 400,
                      ),
                    ),
                    Positioned(
                      right: 12.w,
                      top: 12.w,
                      child: Container(
                        padding: AppStyle.edgeInsetsH12
                            .copyWith(top: 4.w, bottom: 4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: AppStyle.radius24,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.whatshot,
                              color: Colors.orange,
                              size: 20.w,
                            ),
                            AppStyle.hGap4,
                            Text(
                              Utils.onlineToString(online),
                              style: TextStyle(
                                fontSize: 18.w,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppStyle.vGap12,
              Padding(
                padding: AppStyle.edgeInsetsH20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48.w,
                      child: focusNode.isFoucsed.value
                          ? Marquee(
                              text: title,
                              style: AppStyle.textStyleWhite.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.w,
                              ),
                              startAfter: const Duration(seconds: 1),
                              velocity: 30,
                              blankSpace: 100.w,
                              scrollAxis: Axis.horizontal,
                            )
                          : Text(
                              title,
                              style: AppStyle.textStyleWhite.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.w,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    AppStyle.vGap4,
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white70,
                          size: 24.w,
                        ),
                        AppStyle.hGap8,
                        Expanded(
                          child: Text(
                            anchor,
                            style: AppStyle.subTextStyleWhite.copyWith(
                              fontSize: 22.w,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppStyle.vGap16,
            ],
          ),
        ),
      ),
    );
  }
}
