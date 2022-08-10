#include "include/flutter_router/flutter_router_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_router_plugin.h"

void FlutterRouterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_router::FlutterRouterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
