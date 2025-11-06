package com.flutter.notifyvisitors;

import io.flutter.plugin.platform.PlatformView;
import android.content.Context;
import android.view.View;
import com.notifyvisitors.nudges.NotifyVisitorsNativeDisplay;
import android.widget.TextView;
import android.graphics.Color;
import android.util.Log;


//PlatformView that uses your native SDK View
public class NotifyVisitorsEmbedPlatformView implements PlatformView {
    private final NotifyVisitorsNativeDisplay myView;

    public NotifyVisitorsEmbedPlatformView(Context context, String propertyID) {
        Log.d("nvNudges Java file", " load propertyID: " + propertyID);
        myView = new NotifyVisitorsNativeDisplay(context);
        myView.loadContent(propertyID);
    }

    @Override
    public View getView() {
        return myView;
    }

    @Override
    public void dispose() {}
}
