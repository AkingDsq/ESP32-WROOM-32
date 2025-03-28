// SpeechResultReceiver.java
package org.qtproject.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import java.util.ArrayList;

public class SpeechResultReceiver {
    // Native方法声明
    private static native void onRecognitionResult(String result);
    private static native void onRecognitionError(String error);

    public static void handleActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1001) { // SPEECH_REQUEST_CODE
            if (resultCode == Activity.RESULT_OK && data != null) {
                ArrayList<String> results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                if (results != null && !results.isEmpty()) {
                    onRecognitionResult(results.get(0));
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                onRecognitionError("语音识别被取消");
            }
        }
    }
}
