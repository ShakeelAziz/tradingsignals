package com.tranding_signal_system

import io.flutter.plugin.common.PluginRegistry

object FirebaseCloudMessagingPlugin {
fun registerWith(pluginRegistry: PluginRegistry){
    if (alreadyRegistereWith(pluginRegistry))return
    registerWith(pluginRegistry)
}

    private fun alreadyRegistereWith(pluginRegistry: PluginRegistry): Boolean {
        val key = FirebaseCloudMessagingPlugin:: class.java.canonicalName
    if (pluginRegistry.hasPlugin(key)) return true
        pluginRegistry.registrarFor(key)
        return false
    }
}
