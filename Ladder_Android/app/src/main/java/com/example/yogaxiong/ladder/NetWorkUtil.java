package com.example.yogaxiong.ladder;

import android.app.Application;
import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;


/**
 * Created by YogaXiong on 2017/4/6.
 */


public class NetWorkUtil  {
    private NetWorkUtil() {}
    private Context mContext;
    private  static final NetWorkUtil shared = new NetWorkUtil();
    public static NetWorkUtil getInstance() {
        return shared;
    }

    private RequestQueue requestQueue;

    private void config() {
    }

    public void getResponse(Context context, String url, final CallBack callBack) {
        if (context == null) {
            mContext = context;
        }
        if (requestQueue == null) {
            requestQueue = Volley.newRequestQueue(context);
        }

        StringRequest request = new StringRequest(url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        String result = response;
//                        try {
//                            result = new String(response.getBytes("gbk"),"utf-8");
//                        } catch (UnsupportedEncodingException e) {
//                            e.printStackTrace();
//                        }
                        callBack.successCallBack(result);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        callBack.failureCallBack(error.getMessage());
                    }
                });

        requestQueue.add(request);
    }

    interface CallBack {
        void successCallBack(String result);
        void failureCallBack(String result);
    }
}
