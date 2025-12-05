package ir.edrissatiyari.ramzyar

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.view.WindowManager
import androidx.core.content.ContextCompat
import androidx.preference.PreferenceManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val backgroundChannel = "ramzyar/background"
    private val autofillChannel = "ramzyar/autofill"
    private val securityChannel = "ramzyar/security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, backgroundChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val requestBattery = call.argument<Boolean>("requestBattery") ?: false
                        if (requestBattery) {
                            requestBatteryExemption()
                        }
                        startMonitorService()
                        result.success(true)
                    }
                    "stopService" -> {
                        stopMonitorService()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, autofillChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "cacheCredentials" -> {
                        val username = call.argument<String>("username")
                        val password = call.argument<String>("password")
                        cacheAutofill(username, password)
                        result.success(true)
                    }
                    "openAutofillSettings" -> {
                        openAutofillSettings()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, securityChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSecure" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        setSecureWindow(enabled)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun startMonitorService() {
        val intent = Intent(this, ClipboardMonitorService::class.java)
        ContextCompat.startForegroundService(this, intent)
    }

    private fun stopMonitorService() {
        val intent = Intent(this, ClipboardMonitorService::class.java)
        stopService(intent)
    }

    private fun requestBatteryExemption() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:$packageName")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
            }
        }
    }

    private fun cacheAutofill(username: String?, password: String?) {
        if (username.isNullOrEmpty() || password.isNullOrEmpty()) return
        val prefs = PreferenceManager.getDefaultSharedPreferences(this)
        prefs.edit()
            .putString("autofill_username", username)
            .putString("autofill_password", password)
            .apply()
    }

    private fun openAutofillSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_REQUEST_SET_AUTOFILL_SERVICE).apply {
                data = Uri.parse("package:$packageName")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
        }
    }

    private fun setSecureWindow(enabled: Boolean) {
        runOnUiThread {
            if (enabled) {
                window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            } else {
                window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}
