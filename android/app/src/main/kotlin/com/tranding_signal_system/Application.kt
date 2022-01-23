package com.tranding_signal_system

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith
import io.flutter.plugins.firebase.core.FlutterFirebasePluginRegistry
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin

class Application() : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(registry: PluginRegistry?) {
        val key: String? = FlutterFirebaseMessagingPlugin::class.java.canonicalName
        if (!registry?.hasPlugin(key)!!) {
            FirebaseCloudMessagingPlugin.registerWith(registry);
        }
    }
}