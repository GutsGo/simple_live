import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitchtv_tv_app/app/app_focus_node.dart';
import 'package:stitchtv_tv_app/app/app_style.dart';
import 'package:stitchtv_tv_app/widgets/highlight_widget.dart';

class HomeBigButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final AppFocusNode focusNode;
  final Function()? onTap;
  final bool autofocus;
  const HomeBigButton({
    required this.iconData,
    required this.text,
    this.onTap,
    required this.focusNode,
    this.autofocus = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return HighlightWidget(
      onTap: onTap,
      autofocus: autofocus,
      focusNode: focusNode,
      borderRadius: AppStyle.radius20,
      child: Container(
        padding: AppStyle.edgeInsetsA32,
        decoration: BoxDecoration(
          color: AppColors.appleGray,
          borderRadius: AppStyle.radius20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 56.w,
              color: Colors.white,
            ),
            AppStyle.vGap16,
            Text(
              text,
              style: AppStyle.textStyleWhite.copyWith(
                fontSize: 28.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
