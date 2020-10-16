package com.example.jellyflut

import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.jellyflut/videoPlayer"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        fun getListOfCodec(): ArrayList<String> {
            val numCodecs = MediaCodecList.ALL_CODECS;
            val nbOfCodec = MediaCodecList(numCodecs).codecInfos.size;
            val codecs = ArrayList<String>();
            for (i in 0 until nbOfCodec) {
                if (!MediaCodecList(numCodecs).codecInfos[i].isEncoder) {
                    codecs.add(MediaCodecList(numCodecs).codecInfos[i].name);
                    for (element in MediaCodecList(numCodecs).codecInfos[i].supportedTypes)
                        codecs.add(element.toString());
                }
            }
            return codecs;
        }
        
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "getListOfCodec") {
                // val codecs = call.argument<ArrayList<String>>("codecs");
                // val isSupported = isCodecSupported(codecs!!);
                // result.error("Null", "codecs params null", "isCodecSupported has been passed null parameters");
                val listOfCodec = getListOfCodec();
                result.success(listOfCodec)
            } else {
                result.notImplemented()
            }
        }
    }
}
