import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:stitchtv_app/app/app_style.dart';
import 'package:stitchtv_app/modules/search/douyin/douyin_search_controller.dart';
import 'package:stitchtv_app/routes/app_navigation.dart';
import 'package:stitchtv_app/widgets/keep_alive_wrapper.dart';
import 'package:stitchtv_app/widgets/status/app_loadding_widget.dart';

class DouyinSearchView extends StatelessWidget {
  const DouyinSearchView({Key? key}) : super(key: key);
  DouyinSearchController get controller => Get.find<DouyinSearchController>();

  @override
  Widget build(BuildContext context) {
    var roomRowCount = MediaQuery.of(context).size.width ~/ 200;
    if (roomRowCount < 2) roomRowCount = 2;

    var userRowCount = MediaQuery.of(context).size.width ~/ 500;
    if (userRowCount < 1) userRowCount = 1;
    return KeepAliveWrapper(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Padding(
                padding: AppStyle.edgeInsetsA12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "暂不支持抖音搜索，请打开浏览器搜索，然后复制直播间链接进行解析",
                      textAlign: TextAlign.center,
                    ),
                    TextButton.icon(
                      onPressed: controller.openBrowser,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text("打开浏览器"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InAppWebView(
            onWebViewCreated: controller.onWebViewCreated,
            onLoadStop: controller.onLoadStop,
            onLoadStart: controller.onLoadStart,
            initialSettings: InAppWebViewSettings(
              useOnLoadResource: true,
              javaScriptEnabled: true,
              userAgent:
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1 Edg/118.0.0.0",
              useShouldOverrideUrlLoading: true,
              javaScriptCanOpenWindowsAutomatically: true,
              supportMultipleWindows: true,
            ),
            onCreateWindow: controller.onCreateWindow,
            onUpdateVisitedHistory: controller.onUpdateVisitedHistory,
            shouldOverrideUrlLoading: (webController, navigationAction) async {
              var uri = navigationAction.request.url;
              if (uri == null) {
                return NavigationActionPolicy.ALLOW;
              }

              // 拦截非 http/https 协议（如 snssdk、aweme 等 Deep Link）
              if (uri.scheme != "http" && uri.scheme != "https") {
                return NavigationActionPolicy.CANCEL;
              }

              // 拦截直播间 URL，直接进入 App 原生播放
              String urlStr = uri.toString();
              String? id = controller.extractRoomId(urlStr);
              if (id != null && id.isNotEmpty) {
                AppNavigator.toLiveRoomDetail(
                    site: controller.site, roomId: id);
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
          Obx(
            () => Visibility(
              visible: controller.pageLoadding.value,
              child: const AppLoaddingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
