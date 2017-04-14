package com.example.yogaxiong.ladder;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by YogaXiong on 2017/4/11.
 */


public class Config {
    static private final String CONFIG_FILE_NAME = "com.yogaxiong.ladder.Config";
    static private final String URL_KEY = "com.yogaxiong.ladder.url_key";
    static private String defaultUrl = "http://free.ishadow.online/";
    static private String url; //TODO: 用户自己修改，热更新


    public static String getUrl() {
        Context context = MyApplication.getContext();
        SharedPreferences sp = context.getSharedPreferences(CONFIG_FILE_NAME, Context.MODE_PRIVATE);
        String url = sp.getString(URL_KEY, defaultUrl);
        return url;
    }

    public static void setUrl(String url) {
        Context context = MyApplication.getContext();
        SharedPreferences.Editor editor = context.getSharedPreferences(CONFIG_FILE_NAME, Context.MODE_PRIVATE).edit();
        editor.putString(URL_KEY, url);
        editor.commit();
        Config.url = url;
    }
}