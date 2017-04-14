package com.example.yogaxiong.ladder;

import android.app.Application;
import android.content.Context;


/**
 * Created by YogaXiong on 2017/4/14.
 */

public class MyApplication extends Application {
    public static final String name = "Ichat";
    private static Context context;

    @Override
    public void onCreate() {
        super.onCreate();
        context = this.getApplicationContext();
    }

    public String getName() {
        return name;
    }

    public static Context getContext() {
        return context;
    }
}
