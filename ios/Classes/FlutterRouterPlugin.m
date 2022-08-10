#import "FlutterRouterPlugin.h"
#if __has_include(<flutter_router/flutter_router-Swift.h>)
#import <flutter_router/flutter_router-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_router-Swift.h"
#endif

@implementation FlutterRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterRouterPlugin registerWithRegistrar:registrar];
}
@end
