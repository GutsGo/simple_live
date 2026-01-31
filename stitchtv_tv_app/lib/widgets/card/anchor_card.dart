import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitchtv_tv_app/app/app_focus_node.dart';
import 'package:stitchtv_tv_app/app/app_style.dart';
import 'package:stitchtv_tv_app/app/sites.dart';
import 'package:stitchtv_tv_app/routes/app_navigation.dart';
import 'package:stitchtv_tv_app/widgets/highlight_widget.dart';
import 'package:stitchtv_tv_app/widgets/net_image.dart';

class AnchorCard extends StatelessWidget {
  final String siteId;
  final String face;
  final String name;
  final String roomId;
  final int liveStatus;
  final bool autofocus;
  final Function()? onTap;
  final AppFocusNode? focusNode;
  const AnchorCard({
    required this.face,
    required this.siteId,
    required this.name,
    required this.liveStatus,
    required this.roomId,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var site = Sites.allSites[siteId]!;
    var focusNode = this.focusNode ?? AppFocusNode();
    return HighlightWidget(
      onTap: onTap ??
          () {
            AppNavigator.toLiveRoomDetail(site: site, roomId: roomId);
          },
      focusNode: focusNode,
      autofocus: autofocus,
      borderRadius: AppStyle.radius20,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appleGray,
          borderRadius: AppStyle.radius20,
        ),
        child: Stack(
          children: [
            Padding(
              padding: AppStyle.edgeInsetsA24,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2.w),
                    ),
                    child: NetImage(
                      face,
                      width: 100.w,
                      height: 100.w,
                      borderRadius: 100.w,
                      cacheWidth: 100,
                    ),
                  ),
                  AppStyle.hGap24,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppStyle.textStyleWhite.copyWith(
                            fontSize: 32.w,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppStyle.vGap4,
                        Row(
                          children: [
                            Image.asset(
                              site.logo,
                              width: 28.w,
                            ),
                            AppStyle.hGap8,
                            Text(
                              site.name,
                              style: AppStyle.subTextStyleWhite.copyWith(
                                fontSize: 22.w,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (liveStatus == 2)
              Positioned(
                right: 12.w,
                top: 12.w,
                child: Container(
                  padding:
                      AppStyle.edgeInsetsH12.copyWith(top: 4.w, bottom: 4.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: AppStyle.radius24,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppStyle.hGap8,
                      Text(
                        "直播中",
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
    );
  }
}
