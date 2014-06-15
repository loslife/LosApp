package com.yilos.losapp.api;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.LosSSLFactory;
import com.yilos.losapp.json.JsonUtils;


import android.content.Context;
import android.os.Handler;
import android.util.Base64;

public class ApiClient 
{
	// 请求超时
    private static int connectionTimeout = 3000;
	// 读取超时
	private static int soTimeout = 5000;
	
	public static String _post(Context appContext,String url,List<NameValuePair> param)
	{
		StringBuilder response = new StringBuilder();
		HttpsURLConnection conn = null;
		BufferedReader br = null;
		Reader reader = null;
		try {
			URL reqUrl = new URL(url);
			conn = (HttpsURLConnection) reqUrl.openConnection();
			// 设置ssl工厂
			LosSSLFactory losSSLFactory = new LosSSLFactory();
			conn.setSSLSocketFactory(losSSLFactory.getFactory(appContext));
			conn.setRequestMethod("POST");
			// 忽略主机名验证
			conn.setHostnameVerifier(new HostnameVerifier() {
				@Override
				public boolean verify(String arg0, SSLSession arg1) {
					return true;
				}
			});
			
			conn.setConnectTimeout(connectionTimeout);
			conn.setReadTimeout(soTimeout);
			OutputStream os = conn.getOutputStream();
			BufferedWriter writer = new BufferedWriter(
			        new OutputStreamWriter(os, "UTF-8"));
			if(param!=null)
			{
				writer.write(getQuery(param));
			}
			writer.flush();
			writer.close();
			os.close();
			// 读取结果
			reader = new InputStreamReader(conn.getInputStream());
			br = new BufferedReader(reader);
			String line = "";
			while ((line = br.readLine()) != null) {
				response.append(line);
				response.append('\n');
			}
			return response.toString();
		} catch (Exception e) {
			return null;
		} finally
		{
			conn.disconnect();
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}
	
	
	public static String _get(Context appContext,String url)
	{
		StringBuilder response = new StringBuilder();
		HttpsURLConnection conn = null;
		BufferedReader br = null;
		Reader reader = null;
		try {
			URL reqUrl = new URL(url);
			conn = (HttpsURLConnection) reqUrl.openConnection();
			// 设置ssl工厂
			LosSSLFactory losSSLFactory = new LosSSLFactory();
			conn.setSSLSocketFactory(losSSLFactory.getFactory(appContext));
			conn.setRequestMethod("GET");
			// 忽略主机名验证
			conn.setHostnameVerifier(new HostnameVerifier() {
				@Override
				public boolean verify(String arg0, SSLSession arg1) {
					return true;
				}
			});
			
			conn.setConnectTimeout(connectionTimeout);
			conn.setReadTimeout(soTimeout);
			
			// 读取结果
			reader = new InputStreamReader(conn.getInputStream());
			br = new BufferedReader(reader);
			String line = "";
			while ((line = br.readLine()) != null) {
				response.append(line);
				response.append('\n');
			}
			return response.toString();
		} catch (Exception e) {
			return null;
		} finally
		{
			conn.disconnect();
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}
	
	public static ServerResponse login(Context appContext, String username, String pwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("pwd", pwd));
				
		String loginurl ="";
		/*{
		  "code" : 0,
		  result:{
			“message" : "ok"
		  }
		}*/
		
		//String json = "{'code' : 0,result:{'message' : 'ok'}}";
		String json = "{\"code\":0,\"result\":{\"message\":\"ok\"}}";
		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		rt.setMessage("ok");
		res.setResult(rt);
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
			return resp;

	}
	
	private static String getQuery(List<NameValuePair> params) throws UnsupportedEncodingException
	{
	    StringBuilder result = new StringBuilder();
	    boolean first = true;

	    for (NameValuePair pair : params)
	    {
	        if (first)
	            first = false;
	        else
	            result.append("&");

	        result.append(URLEncoder.encode(pair.getName(), "UTF-8"));
	        result.append("=");
	        result.append(URLEncoder.encode(pair.getValue(), "UTF-8"));
	    }

	    return result.toString();
	}
	
}
