import 'package:stitchtv_app/app/controller/base_controller.dart';
import 'package:stitchtv_app/app/sites.dart';
import 'package:stitchtv_core/stitchtv_core.dart';

class HomeListController extends BasePageController<LiveRoomItem> {
  final Site site;
  HomeListController(this.site);

  @override
  Future<List<LiveRoomItem>> getData(int page, int pageSize) async {
    var result = await site.liveSite.getRecommendRooms(page: page);

    return result.items;
  }
}
