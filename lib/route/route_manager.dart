import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_router/route/route_interceptor.dart';
import 'package:flutter_router/route/route_match.dart';

///路由管理器
class RouteManager {
  static RouteManager? _instance;

  final List<RouteInterceptor> _interceptorList = [];

  static RouteManager get instance => _getInstance();

  List<RouteInterceptor> get interceptorList => _interceptorList;

  static RouteManager _getInstance() {
    _instance ??= RouteManager();
    return _instance!;
  }

  ///路由队列
  List<String> routePathList = [];

  ///增加拦截器
  void addInterceptor(RouteInterceptor routeInterceptor) {
    _interceptorList.add(routeInterceptor);
  }

  ///模态返回
  void navigateModelBack(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    final bool canPop = Navigator.of(context).canPop();
    if (canPop) {
      Navigator.of(context).pop();
    }
  }

  ///路由返回
  void navigateBack<T>(BuildContext context,
      {int prePageRoute = -1, String? routeName, T? result}) {
    FocusScope.of(context).requestFocus(FocusNode());
    final bool canPop = Navigator.of(context).canPop();
    if (canPop) {
      ///如果设置了回退路径名
      if (routeName?.isNotEmpty == true) {
        int index = routePathList.indexOf(routeName!);

        ///如果在当前路由栈中查找到，则回退到指定路由名页面
        if (index != -1) {
          for (int i = 0; i < routePathList.length - (index + 1); i++) {
            routePathList.removeLast();
          }
        }
        Navigator.of(context).popUntil(ModalRoute.withName(routeName));
      } else if (prePageRoute != -1) {
        ///如果根据层级回退
        if (routePathList.length > prePageRoute) {
          final String routeName =
              routePathList.elementAt(routePathList.length - 1 - prePageRoute);
          for (int i = 0; i < prePageRoute; i++) {
            routePathList.removeLast();
          }
          Navigator.of(context).popUntil(ModalRoute.withName(routeName));
        } else {
          debugPrint('警告，回退路由层级过多');
        }
      } else {
        routePathList.removeLast();
        Navigator.of(context).pop(result);
      }
    }
    debugPrint(routePathList.toString());
  }

  void navigateTo<T>(BuildContext context, String path,
      {Map<String, dynamic>? arguments,
      bool replace = false,
      bool clearStack = false,
      Function(T data)? resultCallBack}) {
    ///传入路径为空，无任何动作
    if (path.isEmpty) return;

    ///判定首地址不为/，说明为uri(格式为scheme://host?queryParameters)
    ///bp://host?queryParameters
    if (!path.startsWith("/")) {
      final Uri uri = Uri.parse(path);
      if (uri.scheme != 'bp') return;
      path = uri.path;
      if (arguments == null && uri.queryParameters.isNotEmpty) {
        arguments = <String, dynamic>{};
      }
      uri.queryParameters.forEach((String key, String value) {
        arguments![key] = value;
      });
    }

    ///查找拦截器是否拦截当前路由
    if (_interceptorList.isNotEmpty) {
      for (int i = 0; i < _interceptorList.length; i++) {
        final RouteInterceptorResult res =
            _interceptorList[i].addInterceptor(path, arguments);
        if (res.isIntercept) {
          path = res.redirectPath;
          break;
        }
      }
    }
    if (_isNativeRoute(path)) {
      // NativeManager.getInstance().navigateTo(path, data: arguments);
    } else {
      final RouteSettings settings =
          RouteSettings(name: path, arguments: arguments);
      final Route route = RouteMatch.getInstance()
          .generateRoute(settings, arguments: arguments);
      if (clearStack) {
        routePathList.clear();
        routePathList.add(path);
        Navigator.of(context)
            .pushAndRemoveUntil(route, (Route check) => false)
            .then((value) {
          resultCallBack?.call(value);
        });
      }
      if (replace) {
        routePathList.removeLast();
        routePathList.add(path);
        Navigator.of(context).pushReplacement(route).then((value) {
          resultCallBack?.call(value);
        });
      }
      if (routePathList.isNotEmpty && path == routePathList.last) {
        routePathList.removeLast();
        routePathList.add(path);
        Navigator.of(context).pushReplacement(route).then((value) {
          resultCallBack?.call(value);
        });
      } else {
        routePathList.add(path);
        Navigator.of(context).push(route).then((value) {
          resultCallBack?.call(value);
        });
      }
    }
    debugPrint(routePathList.toString());
  }

  bool _isNativeRoute(String pagePath) {
    final List<String> pagePathList = pagePath.split('/');
    return 'native' == pagePathList[1];
  }
}
