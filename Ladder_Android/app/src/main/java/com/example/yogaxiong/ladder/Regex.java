package com.example.yogaxiong.ladder;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by YogaXiong on 2017/4/11.
 */

public class Regex {

    static ArrayList<String> getItemList(String parse) {
        String[] tmp = parse.split("<div class=\"hover-text\">");
        ArrayList<String> rs = new ArrayList<String>();
        for (int i = 1; i < tmp.length; i++) {
            rs.add(tmp[i]);
        }
        return rs;
    }

    static String getItem(String re, String parse) {
        Pattern p = Pattern.compile(re, Pattern.DOTALL);
        Matcher m = p.matcher(parse);
        return m.find() ? m.group() : "";
    }


    static class RegularExpression  {
        static final String LIST_TAG = "<div class=\"hover-bg\">(.+)</div>";
        static final String IP_TAG = "IP Address:<span id=\"(.*?)\">(.*?)</span>";
        static final String PORT_TAG = "<h4>Portï¼\u009A(\\d+?)</h4>";
        static final String PASSWORD_TAG = "Password:<span id=\"\\b(.*?)\">(.*?)</span>";
        static final String ENCRYPTION_TAG = "Method:(.*?)</h4>";
        static final String QRCODE_TAG = "a href=\"(.*?)\"";

        static final String IP = "\\w+\\W\\w+\\W\\w+";
        static final String PORT = "\\d{2,9}";
        static final String PASSWORD = "\\d+";
        static final String QRCODE = "\\w{3}/\\w{2}/\\w{3,5}\\Wpng";
    }

}