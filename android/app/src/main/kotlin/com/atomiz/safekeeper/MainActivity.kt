package com.atomiz.safekeeper

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.safeKeeper"

    private var pickedUri: Uri? = null

    private var res: MethodChannel.Result? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            res = result
            if (call.method == "openFileChooser") {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)

                    intent.type = "*/*"

                    intent.putExtra(Intent.EXTRA_LOCAL_ONLY, true)

                    startActivityForResult(intent, 10)
                    if (res == null)
                        result.success(null)
                } else {
                    result.success(null)
                }
            } else if (call.method == "loadFile") {
                try {
                    if (pickedUri != null) {
                        var path: String? = null
                        val backgroundThread = object : Thread("background") {
                            override fun run() {
                                val uriObj = URIHelper()
                                val fileName = try {
                                    pickedUri?.let { uriObj.getFileName(it, context) }
                                } catch (e: java.lang.Exception) {
                                    null
                                }
                                path = pickedUri?.let { URIHelper().openFileStream(context, it) }
                                Handler(Looper.getMainLooper()).post {
                                    // eventSink?.success(mapOf("status" to "end", "fileName" to fileName, "path" to path))
                                    res?.success(path)
                                }
                            }
                        }
                        backgroundThread.start()
//                        res?.success(path)
                    } else {
                        result.success(null)
                    }
                } catch (e: Exception) {
//                    result.success("${e.message} and ${e.cause} and ${e.toString()}")
                    result.success(false)
                }
            } else if (call.method == "deleteFile") {
                try {
                    if (pickedUri != null) {
                        DocumentsContract.deleteDocument(contentResolver, pickedUri)
                        pickedUri = null
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                } catch (e: Exception) {
//                    result.success("${e.message} and ${e.cause} and ${e.toString()}")
                    result.success(false)
                }
            } else if (call.method == "toast") {
                    val message = call.argument<String>("message")
                    Toast.makeText(this@MainActivity, message, Toast.LENGTH_SHORT).show()
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        //        res?.success("Entered in this area")
        if (requestCode == 10 && resultCode == Activity.RESULT_OK) {
            if (data != null) {
                val uri = data.data
                pickedUri = uri
                val uriObj = URIHelper()
                val fileName = try {
                    uri?.let { uriObj.getFileName(it, context) }
                } catch (e: java.lang.Exception) {
                    null
                }
                var fileSize = try {
                    uriObj.getSize(context, uri)?.toDouble()
                } catch (e: NumberFormatException) {
                    null
                }
                if (fileSize != null) {
                    fileSize /= 1000
                }

                res?.success(mapOf("fileName" to fileName, "size" to fileSize))
            } else {
                res?.success(null)
            }
        }
    }
}
