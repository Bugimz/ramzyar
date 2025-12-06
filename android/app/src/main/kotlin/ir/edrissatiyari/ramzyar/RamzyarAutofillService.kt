package ir.edrissatiyari.ramzyar

import android.app.assist.AssistStructure
import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.FillCallback
import android.service.autofill.FillContext
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.SaveCallback
import android.service.autofill.SaveRequest
import android.view.View
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.preference.PreferenceManager

class RamzyarAutofillService : AutofillService() {

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        val prefs = PreferenceManager.getDefaultSharedPreferences(this)
        val username = prefs.getString("autofill_username", null)
        val password = prefs.getString("autofill_password", null)

        if (username.isNullOrEmpty() || password.isNullOrEmpty()) {
            callback.onSuccess(null)
            return
        }

        val contexts: List<FillContext> = request.fillContexts
        if (contexts.isEmpty()) {
            callback.onSuccess(null)
            return
        }

        val structure: AssistStructure = contexts.last().structure
        val fieldFinder = FieldFinder()
        val ids = fieldFinder.findFields(structure)

        val presentation = RemoteViews(packageName, android.R.layout.simple_list_item_1).apply {
            setTextViewText(android.R.id.text1, "رمزیار")
        }

        val datasetBuilder = android.service.autofill.Dataset.Builder()
        ids.usernames.forEach { id ->
            datasetBuilder.setValue(id, AutofillValue.forText(username), presentation)
        }
        ids.passwords.forEach { id ->
            datasetBuilder.setValue(id, AutofillValue.forText(password), presentation)
        }

        val dataset = datasetBuilder.build()
        val response = FillResponse.Builder()
            .addDataset(dataset)
            .build()
        callback.onSuccess(response)
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        val prefs = PreferenceManager.getDefaultSharedPreferences(this)
        val usernames = mutableListOf<String>()
        val passwords = mutableListOf<String>()

        request.fillContexts.forEach { context ->
            val structure = context.structure
            FieldFinder().collectValues(structure, usernames, passwords)
        }

        val username = usernames.firstOrNull()
        val password = passwords.firstOrNull()
        if (!username.isNullOrEmpty() && !password.isNullOrEmpty()) {
            prefs.edit()
                .putString("autofill_username", username)
                .putString("autofill_password", password)
                .apply()
        }
        callback.onSuccess()
    }
}

private class FieldFinder {
    data class Fields(val usernames: List<AutofillId>, val passwords: List<AutofillId>)

    fun findFields(structure: AssistStructure): Fields {
        val usernames = mutableListOf<AutofillId>()
        val passwords = mutableListOf<AutofillId>()
        val windowNodes = structure.run { (0 until windowNodeCount).map { getWindowNodeAt(it) } }
        windowNodes.forEach { traverseNode(it.rootViewNode, usernames, passwords) }
        return Fields(usernames, passwords)
    }

    fun collectValues(structure: AssistStructure, usernames: MutableList<String>, passwords: MutableList<String>) {
        val windowNodes = structure.run { (0 until windowNodeCount).map { getWindowNodeAt(it) } }
        windowNodes.forEach { collectNodeValues(it.rootViewNode, usernames, passwords) }
    }

    private fun traverseNode(
        node: AssistStructure.ViewNode,
        usernames: MutableList<AutofillId>,
        passwords: MutableList<AutofillId>
    ) {
        val hints = node.autofillHints
        hints?.forEach { hint ->
            when (hint) {
                View.AUTOFILL_HINT_USERNAME, View.AUTOFILL_HINT_EMAIL_ADDRESS -> node.autofillId?.let { usernames.add(it) }
                View.AUTOFILL_HINT_PASSWORD -> node.autofillId?.let { passwords.add(it) }
            }
        }
        for (i in 0 until node.childCount) {
            node.getChildAt(i)?.let { traverseNode(it, usernames, passwords) }
        }
    }

    private fun collectNodeValues(
        node: AssistStructure.ViewNode,
        usernames: MutableList<String>,
        passwords: MutableList<String>
    ) {
        val value = node.autofillValue
        val hints = node.autofillHints
        if (value != null && value.isText) {
            hints?.forEach { hint ->
                when (hint) {
                    View.AUTOFILL_HINT_USERNAME, View.AUTOFILL_HINT_EMAIL_ADDRESS -> usernames.add(value.textValue.toString())
                    View.AUTOFILL_HINT_PASSWORD -> passwords.add(value.textValue.toString())
                }
            }
        }
        for (i in 0 until node.childCount) {
            node.getChildAt(i)?.let { collectNodeValues(it, usernames, passwords) }
        }
    }
}
