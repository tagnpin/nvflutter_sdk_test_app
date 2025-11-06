package com.flutter.notifyvisitors;

import android.content.Context;

import java.util.Map;
import android.util.Log;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

//ViewFactory to wrap your SDK view
public class NotifyVisitorsEmbedViewFactory  extends PlatformViewFactory {

    public NotifyVisitorsEmbedViewFactory(io.flutter.plugin.common.BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        String propertyName = "";
        if (args instanceof Map) {
            Map argsMap = (Map) args;
            Object prop = argsMap.get("propertyName");
            if (prop != null) {
                propertyName = prop.toString();
            }
        }
        return new NotifyVisitorsEmbedPlatformView(context, propertyName);  
    }
}
