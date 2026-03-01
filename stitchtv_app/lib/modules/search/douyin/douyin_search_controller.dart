import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stitchtv_app/app/controller/base_controller.dart';
import 'package:stitchtv_app/app/sites.dart';
import 'package:stitchtv_app/routes/app_navigation.dart';
import 'package:stitchtv_app/routes/route_path.dart';
import 'package:stitchtv_core/stitchtv_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DouyinSearchController extends BaseController {
  InAppWebViewController? webViewController;

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  RxList<LiveRoomItem> list = <LiveRoomItem>[].obs;

  String keyword = "";

  /// 搜索模式，0=直播间，1=主播
  var searchMode = 0.obs;
  final Site site;
  DouyinSearchController(this.site);

  var searchUrl = "https://www.douyin.com/search/dnf?type=live";

  /// 防止重复处理
  bool _isHandlingUserPage = false;

  void reloadWebView() {
    if (keyword.isEmpty) return;
    searchUrl =
        "https://www.douyin.com/search/${Uri.encodeComponent(keyword)}?type=live";
    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(searchUrl)),
    );
  }

  void onLoadStop(InAppWebViewController controller, Uri? uri) async {
    pageLoadding.value = false;
    CoreLog.d('[抖音搜索] onLoadStop: $uri');
    if (uri != null && _isUserProfileUrl(uri)) {
      CoreLog.d('[抖音搜索] onLoadStop 检测到用户主页');
      if (!_isHandlingUserPage) {
        _isHandlingUserPage = true;
        await _tryExtractRoomFromPage(controller);
        _isHandlingUserPage = false;
      }
    }
  }

  void onLoadStart(InAppWebViewController controller, Uri? uri) async {
    pageLoadding.value = true;
    CoreLog.d('[抖音搜索] onLoadStart: $uri');
  }

  /// 判断 URL 是否为用户主页
  bool _isUserProfileUrl(Uri uri) {
    return uri.path.contains('/user/');
  }

  // ============================================================
  //  核心：从用户主页提取直播间 ID
  // ============================================================

  Future<void> _tryExtractRoomFromPage(
      InAppWebViewController controller) async {
    try {
      // 等页面内容渲染（移动版抖音较慢）
      await Future.delayed(const Duration(seconds: 3));

      // JS 在页面整体 HTML 中暴力搜索直播间相关数据
      var result = await controller.evaluateJavascript(source: r'''
        (function() {
          try {
            var html = document.documentElement ? document.documentElement.outerHTML : '';

            // live.douyin.com 链接
            var m = html.match(/live\.douyin\.com\/([\w\d]+)/);
            if (m && m[1]) return m[1];

            // room_id
            m = html.match(/room_id[=:]["' ]*(\d{10,})/);
            if (m && m[1]) return m[1];

            // "roomId":"xxx"
            m = html.match(/"roomId"\s*:\s*"(\d+)"/);
            if (m && m[1]) return m[1];

            // "web_rid":"xxx"
            m = html.match(/"web_rid"\s*:\s*"([\w\d]+)"/);
            if (m && m[1]) return m[1];

            // "short_id":"xxx" (非0)
            m = html.match(/"short_id"\s*:\s*"(\d+)"/);
            if (m && m[1] && m[1] !== '0') return m[1];

            // "unique_id":"xxx" (非0)
            m = html.match(/"unique_id"\s*:\s*"(\d+)"/);
            if (m && m[1] && m[1] !== '0') return m[1];

            // z.douyin.com 短链
            m = html.match(/z\.douyin\.com\/([\w]+)/);
            if (m && m[1]) return 'zlink:' + m[1];

            return 'debug:len=' + html.length + ',live=' + (html.indexOf('live') !== -1) + ',room=' + (html.indexOf('room') !== -1);
          } catch(e) {
            return 'error:' + e.toString();
          }
        })();
      ''');

      CoreLog.d('[抖音搜索] JS 提取结果: $result');

      if (result != null &&
          result is String &&
          result.isNotEmpty &&
          result != 'null') {
        // 判断返回类型
        if (result.startsWith('debug:') || result.startsWith('error:')) {
          CoreLog.d('[抖音搜索] JS 无直播间数据: $result');
        } else if (result.startsWith('zlink:')) {
          CoreLog.d('[抖音搜索] 找到短链: $result');
          // 短链暂不处理，走 fallback
        } else {
          // 直接是 roomId 或 webRid
          CoreLog.d('[抖音搜索] 找到直播间: $result，跳转');
          controller.goBack();
          await Future.delayed(const Duration(milliseconds: 300));
          AppNavigator.toLiveRoomDetail(site: site, roomId: result);
          return;
        }
      }

      // Fallback：从 URL 提取 sec_uid，通过 API 查直播间
      var currentUrl = await controller.getUrl();
      CoreLog.d('[抖音搜索] fallback, 当前URL: $currentUrl');
      if (currentUrl != null) {
        var secUid = _extractSecUid(currentUrl.toString());
        if (secUid != null) {
          CoreLog.d('[抖音搜索] 提取到 sec_uid: $secUid，尝试 API');
          var roomId = await _findRoomBySecUid(secUid);
          if (roomId != null) {
            CoreLog.d('[抖音搜索] API 查到直播间: $roomId');
            controller.goBack();
            await Future.delayed(const Duration(milliseconds: 300));
            AppNavigator.toLiveRoomDetail(site: site, roomId: roomId);
            return;
          }
        }
      }

      // 都没找到
      CoreLog.d('[抖音搜索] 未找到直播间信息，回退');
      controller.goBack();
      SmartDialog.showToast("该主播当前未开播或无法获取直播间信息，请点击直播间封面进入");
    } catch (e) {
      CoreLog.d('[抖音搜索] 提取异常: $e');
      controller.goBack();
      SmartDialog.showToast("获取直播间信息失败");
    }
  }

  /// 从 URL 提取 sec_uid
  String? _extractSecUid(String url) {
    var match =
        RegExp(r'/(?:share/)?user/(MS4wLjAB[A-Za-z0-9_-]+)').firstMatch(url);
    return match?.group(1);
  }

  /// 通过 sec_uid 查找直播间
  Future<String?> _findRoomBySecUid(String secUid) async {
    try {
      var dio = Dio();
      var response = await dio.get(
        'https://webcast.amemv.com/webcast/room/reflow/info/',
        queryParameters: {
          "type_id": "0",
          "live_id": "1",
          "room_id": "1",
          "sec_user_id": secUid,
          "version_code": "99.99.99",
          "app_id": "6383",
        },
        options: Options(
          headers: {
            "User-Agent":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15",
          },
        ),
      );
      var result = response.data;
      CoreLog.d('[抖音搜索] reflow API 返回: $result');
      if (result is Map) {
        var data = result['data'];
        if (data is Map) {
          var room = data['room'];
          if (room is Map) {
            var webRid = room['owner']?['web_rid']?.toString();
            if (webRid != null && webRid.isNotEmpty) return webRid;
            var idStr = room['id_str']?.toString();
            if (idStr != null && idStr.isNotEmpty) return idStr;
          }
        }
      }
    } catch (e) {
      CoreLog.d('[抖音搜索] reflow API 失败: $e');
    }
    return null;
  }

  // ============================================================
  //  URL 解析
  // ============================================================

  String? extractRoomId(String urlStr) {
    try {
      var uri = Uri.parse(urlStr);
      if (uri.queryParameters.containsKey("room_id")) {
        return uri.queryParameters["room_id"];
      }
      if (uri.queryParameters.containsKey("web_rid")) {
        return uri.queryParameters["web_rid"];
      }
      var match = RegExp(r"live\.douyin\.com/([\d\w_]+)").firstMatch(urlStr);
      if (match != null) return match.group(1);
      var match2 = RegExp(r"douyin\.com.*?/live/([\d\w_]+)").firstMatch(urlStr);
      if (match2 != null) return match2.group(1);
    } catch (e) {}
    return null;
  }

  // ============================================================
  //  WebView 回调
  // ============================================================

  void onUpdateVisitedHistory(InAppWebViewController controller, Uri? uri,
      bool? androidIsReload) async {
    if (uri == null) return;
    String urlStr = uri.toString();
    CoreLog.d('[抖音搜索] onUpdateVisitedHistory: $urlStr');

    String? id = extractRoomId(urlStr);
    if (id != null && id.isNotEmpty) {
      CoreLog.d('[抖音搜索] 检测到直播间URL, roomId=$id');
      AppNavigator.toLiveRoomDetail(site: site, roomId: id);
      controller.goBack();
      return;
    }

    if (_isUserProfileUrl(uri) && !_isHandlingUserPage) {
      CoreLog.d('[抖音搜索] onUpdateVisitedHistory 检测到用户主页，开始提取');
      _isHandlingUserPage = true;
      await _tryExtractRoomFromPage(controller);
      _isHandlingUserPage = false;
    }
  }

  Future<bool?> onCreateWindow(InAppWebViewController controller,
      CreateWindowAction createWindowAction) async {
    var urlStr = createWindowAction.request.url?.toString() ?? "";
    CoreLog.d('[抖音搜索] onCreateWindow: $urlStr');

    String? id = extractRoomId(urlStr);
    if (id != null && id.isNotEmpty) {
      AppNavigator.toLiveRoomDetail(site: site, roomId: id);
      return false;
    }

    if (urlStr.contains('/user/')) {
      CoreLog.d('[抖音搜索] onCreateWindow 检测到用户主页');
      webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(urlStr)));
      return false;
    }

    return false;
  }

  void openBrowser() {
    launchUrlString(searchUrl);
    Get.offAndToNamed(RoutePath.kTools);
  }
}
