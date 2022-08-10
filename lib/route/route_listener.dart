import 'package:flutter/widgets.dart';
import 'package:flutter_router/route/route_manager.dart';

///路由监听器
class RouteListener extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint("popPage => ${route.settings.name}");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("pushPage => ${route.settings.name}");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint("deletePage => ${route.settings.name}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
        "replacePage => ${oldRoute!.settings.name}, toPage => ${newRoute!.settings.name}");
  }

  @override
  void didStartUserGesture(
      Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint(
        "currentPage => ${route!.settings.name}, prePage => ${previousRoute!.settings.name}");
    RouteManager.instance.routePathList.removeLast();
  }

  @override
  void didStopUserGesture() {}
}
