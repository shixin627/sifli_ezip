#include "include/sifli_ezip/sifli_ezip_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "sifli_ezip_plugin.h"

void SifliEzipPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  sifli_ezip::SifliEzipPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
