package ir.edrissatiyari.ramzyar

import android.content.BroadcastReceiver
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.widget.Toast

class SmsOtpReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION != intent.action) return

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        val body = messages.joinToString(separator = " ") { it.displayMessageBody }

        if (!body.contains("رمز")) return

        val otp = extractOtp(body) ?: return
        copyToClipboard(context, otp)
        Toast.makeText(context, "رمز کپی شد و آماده پیست است", Toast.LENGTH_LONG).show()
    }

    private fun extractOtp(body: String): String? {
        // Matches digits that follow "رمز" or "رمز پویا"
        val keywordPattern = Regex("(?:رمز(?:\\s+پویا)?[^0-9]{0,6})([0-9]{3,8})")
        val keywordMatch = keywordPattern.find(body)
        if (keywordMatch != null) {
            return keywordMatch.groupValues.getOrNull(1)
        }

        // Fallback: if the message mentions "رمز" grab the first 4-8 digit number.
        val fallbackMatch = Regex("\\b([0-9]{4,8})\\b").find(body)
        return fallbackMatch?.groupValues?.getOrNull(1)
    }

    private fun copyToClipboard(context: Context, otp: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("OTP", otp)
        clipboard.setPrimaryClip(clip)
    }
}
