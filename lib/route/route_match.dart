import 'package:flutter/cupertino.dart';

class RouteMatch {
  static RouteMatch? _this;

  final Map<String, RouteHandler> _routes = {};

  Map<String, RouteHandler> get routes => _routes;

  static RouteMatch getInstance() {
    _this ??= RouteMatch();
    return _this!;
  }

  Widget Function(RouteSettings? settings)? onLostPathCallBack;

  Route<dynamic> generateRoute(RouteSettings? settings,
      {Map<String, dynamic>? arguments}) {
    Route<dynamic> route = CupertinoPageRoute<dynamic>(
        settings: settings,
        builder: (BuildContext context) => generateWidget(context, settings));
    return route;
  }

  void addRoute(String path, RouteHandler handler) {
    if (!_routes.containsKey(path)) {
      _routes[path] = handler;
    }
  }

  Widget generateWidget(BuildContext context, RouteSettings? settings) {
    if (_routes.containsKey(settings!.name)) {
      Map<String, dynamic> arguments = {};
      if (settings.arguments != null &&
          settings.arguments is Map<String, dynamic>) {
        arguments = settings.arguments as Map<String, dynamic>;
      }
      return _routes[settings.name]!
          .handler
          .call(Map.unmodifiable(arguments), context);
    } else {
      return onLostPathCallBack?.call(settings) ?? Container();
    }
  }
}

class RouteHandler {
  Function(Map<String, dynamic>? parameters, BuildContext context) handler;

  RouteHandler(this.handler);
}
