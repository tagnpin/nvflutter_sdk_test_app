package com.notifyvisitors.nvflutter_sdk_test_app

import android.app.Application
import com.flutter.notifyvisitors.NotifyvisitorsPlugin

class MyApplication : Application() {

    // NOTE: Replace the below with your own NOTIFYVISITORS_BRAND_ID & NOTIFYVISITORS_BRAND_ENCRYPTION_KEY
    private val NOTIFYVISITORS_BRAND_ENCRYPTION_KEY: String = "515CBDE82C402BDD85E4DFCCFD8904F6"
    private val NOTIFYVISITORS_BRAND_ID: Int = 8115

    override fun onCreate() {
        super.onCreate()

        NotifyvisitorsPlugin.register(this, NOTIFYVISITORS_BRAND_ID, NOTIFYVISITORS_BRAND_ENCRYPTION_KEY);

    }
}
