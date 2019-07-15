package com.fondeadora.mobile.jumio_flutter_example

import io.flutter.app.FlutterApplication
import android.content.Context
import androidx.multidex.MultiDex

class ExampleApplication : FlutterApplication() {

  override fun attachBaseContext(base: Context) {
    super.attachBaseContext(base)
    MultiDex.install(this)
  }

}
