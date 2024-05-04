package com.atomiz.safekeeper

import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import java.io.*
import java.util.*

class URIHelper {
    private val TAG = "URIHelper"

    fun getFileName(uri: Uri, context: Context): String? {
        var uri: Uri = uri
        var result: String? = null

        //if uri is content
        if (uri.scheme != null && uri.scheme.equals("content")) {
            var cursor: Cursor? = null
            try {
                cursor = context.contentResolver.query(uri, null, null, null, null)
                if (cursor != null && cursor.moveToFirst()) {
                    //local filesystem
                    var index: Int = cursor.getColumnIndex("_data")
                    if (index == -1) //google drive
                    {
                        index = cursor.getColumnIndex("_display_name")
                    }
                    result = cursor.getString(index)
                    uri = if (result != null) {
                        Uri.parse(result)
                    } else {
                        return null
                    }
                }
            } catch (ex: Exception) {
                Log.e(TAG, "Failed to decode file name: $ex")
            } finally {
                cursor?.close()
            }
        }
        if (uri.path != null) {
            result = uri.path
            val cut = result?.lastIndexOf('/')
            if (cut != -1) {
                if (result != null) {
                    if (cut != null) {
                        result = result.substring(cut + 1)
                    }
                }
            }
        }
        return result
    }

    fun getSize(context: Context, uri: Uri?): String? {
        var fileSize: String? = null
        val cursor = context.contentResolver
                .query(uri!!, null, null, null, null, null)
        try {
            if (cursor != null && cursor.moveToFirst()) {

                // get file size
                val sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE)
                if (!cursor.isNull(sizeIndex)) {
                    fileSize = cursor.getString(sizeIndex)
                }
            }
        } finally {
            cursor!!.close()
        }
        return fileSize
    }

    fun openFileStream(context: Context, uri: Uri): String? {
        Log.i(TAG, "Caching from URI: $uri")
        var fos: FileOutputStream? = null
        val fileName: String? = getFileName(uri, context)
        val path = context.cacheDir.absolutePath + "/" + (fileName
                ?: Random().nextInt(100000))
        val file = File(path)
        file.parentFile?.mkdirs()
        try {
            fos = FileOutputStream(path)
            try {
                val out = BufferedOutputStream(fos)
                val `in`: InputStream? = context.contentResolver.openInputStream(uri)
                val buffer = ByteArray(8192)
                var len = 0
                if (`in` != null) {
                    while (`in`.read(buffer).also { len = it } >= 0) {
                        out.write(buffer, 0, len)
                    }
                }
                out.flush()
            } finally {
                fos.fd.sync()
            }
        } catch (e: java.lang.Exception) {
            try {
                fos?.close()
            } catch (ex: IOException) {
                Log.e(TAG, "Failed to close file streams: " + e.message, null)
                return null
            } catch (ex: NullPointerException) {
                Log.e(TAG, "Failed to close file streams: " + e.message, null)
                return null
            }
            Log.e(TAG, "Failed to retrieve path: " + e.message, null)
            return null
        }
        Log.d(TAG, "File loaded and cached at:$path")
        return path
    }
}