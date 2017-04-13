package com.example.yogaxiong.ladder;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by YogaXiong on 2017/4/11.
 */



public class Creater {
    private Creater() {}
    private  static final Creater shared = new Creater();
    public static Creater getInstance() {
        return shared;
    }

    public List<Ladder> createLadders(String source) {

        List<Ladder> rs = new ArrayList<>();

        ArrayList<String> tmps = Regex.getItemList(source);
        for(String f : tmps){
            String ipTag = Regex.getItem(Regex.RegularExpression.IP_TAG, f);
            String ip = Regex.getItem(Regex.RegularExpression.IP, ipTag);

            String portTag = Regex.getItem(Regex.RegularExpression.PORT_TAG, f);
            String port = Regex.getItem(Regex.RegularExpression.PORT, portTag);

            String pwdTag = Regex.getItem(Regex.RegularExpression.PASSWORD_TAG, f);
            String pwd = Regex.getItem(Regex.RegularExpression.PASSWORD, pwdTag);

            String eTag = Regex.getItem(Regex.RegularExpression.ENCRYPTION_TAG,f);
            String e = eTag.substring(7, eTag.length() - 5);

            String qrTag = Regex.getItem(Regex.RegularExpression.QRCODE_TAG,f);
            String qr = Config.url + Regex.getItem(Regex.RegularExpression.QRCODE,qrTag);

            Ladder ladder = new Ladder(ip, port, pwd, e, qr);
            rs.add(ladder);

//            LogUtil.e("A", ip);
//            LogUtil.e("B", port);
//            LogUtil.e("C", pwd);
//            LogUtil.e("D", e);
//            LogUtil.e("E", qr );
        }
        return rs;
    }

}
