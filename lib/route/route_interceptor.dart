///
/// * @ProjectName: flutter_router
/// * @Author: qifanxin
/// * @CreateDate: 2022/8/10 19:13
/// * @Description: 文件说明
///

abstract class RouteInterceptor {
  ///需要经过拦截的路由
  List<String> interceptRoutes = [];

  RouteInterceptorResult addInterceptor(
      String path, Map<String, dynamic>? arguments);
}

class RouteInterceptorResult {
  ///是否拦截
  late bool isIntercept;

  ///拦截后跳转的地址
  late String redirectPath;

  RouteInterceptorResult({this.isIntercept = false, this.redirectPath = ""});
}
