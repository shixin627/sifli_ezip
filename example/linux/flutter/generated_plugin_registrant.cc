//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <sifli_ezip/sifli_ezip_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) sifli_ezip_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SifliEzipPlugin");
  sifli_ezip_plugin_register_with_registrar(sifli_ezip_registrar);
}
