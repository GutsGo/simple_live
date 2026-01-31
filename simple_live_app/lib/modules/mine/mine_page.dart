import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/log.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/routes/route_path.dart';
import 'package:simple_live_app/services/signalr_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MinePage extends StatelessWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Get.isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.transparent,
            ),
      child: SafeArea(
        top: !Platform.isMacOS,
        child: ListView(
          padding: AppStyle.edgeInsetsA4,
          children: [
            AppStyle.vGap12,
            _buildCard(
              context,
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: const Text(
                    "乱炖直播",
                    style: TextStyle(height: 1.0),
                  ),
                  subtitle: const Text("StitchTV"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.dialog(AboutDialog(
                      applicationIcon: Image.asset(
                        'assets/images/logo.png',
                        width: 48,
                        height: 48,
                      ),
                      applicationName: "乱炖直播",
                      applicationVersion: "StitchTV",
                      applicationLegalese: "Ver ${Utils.packageInfo.version}",
                    ));
                  },
                ),
              ],
            ),
            AppStyle.vGap12,
            _buildCard(
              context,
              children: [
                ListTile(
                  leading: const Icon(Remix.history_line),
                  title: const Text("观看记录"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kHistory),
                ),
              ],
            ),
            AppStyle.vGap12,
            _buildCard(
              context,
              children: [
                ListTile(
                  leading: const Icon(Remix.account_circle_line),
                  title: const Text("账号管理"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsAccount),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text("数据同步"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSync),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.link),
                  title: const Text("链接解析"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kTools),
                ),
              ],
            ),
            AppStyle.vGap12,
            _buildCard(
              context,
              children: [
                ListTile(
                  leading: const Icon(Remix.moon_line),
                  title: const Text("外观设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kAppstyleSetting),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.home_2_line),
                  title: const Text("主页设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsIndexed),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.play_circle_line),
                  title: const Text("直播设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsPlay),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.text),
                  title: const Text("弹幕设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsDanmu),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.heart_line),
                  title: const Text("关注设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsFollow),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.timer_2_line),
                  title: const Text("定时关闭"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsAutoExit),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.apps_line),
                  title: const Text("其他设置"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Get.toNamed(RoutePath.kSettingsOther),
                ),
                if (kDebugMode) ...[
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Remix.apps_line),
                    title: const Text("测试"),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () async {
                      SignalRService signalRService = SignalRService();
                      await signalRService.connect();
                      var room = await signalRService.createRoom();
                      Log.logPrint(room);
                    },
                  ),
                ],
              ],
            ),
            AppStyle.vGap12,
            _buildCard(
              context,
              children: [
                const ListTile(
                  leading: Icon(Remix.error_warning_line),
                  title: Text("免责声明"),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: Utils.showStatement,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Remix.github_line),
                  title: const Text("开源主页"),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    launchUrlString(
                      "https://github.com/xiaoyaocz/dart_simple_live",
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: AppStyle.radiusM),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(borderRadius: AppStyle.radiusS),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
