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
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.auth.DigestSchemeFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;

import com.google.gson.Gson;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.Constants;
import com.yilos.losapp.common.LosSSLFactory;


import android.content.Context;
import android.os.Bundle;
import android.os.Message;

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
	
	public static String _httpget(String url)
	{

		StringBuilder resultData = new StringBuilder();
		try {
			HttpGet httpReq = new HttpGet(url);
			httpReq.setHeader("xhr", "true");

			DefaultHttpClient httpClient = new DefaultHttpClient();
			// 请求超时
			httpClient.getParams().setParameter(
					CoreConnectionPNames.CONNECTION_TIMEOUT,
					connectionTimeout);
			// 读取超时
			httpClient.getParams().setParameter(
					CoreConnectionPNames.SO_TIMEOUT, soTimeout);
		
			HttpResponse httpResponse = httpClient.execute(httpReq);

			BufferedReader reader = new BufferedReader(new InputStreamReader(
					httpResponse.getEntity().getContent()));
			String inputLine = null;
			// 使用循环来读取获得的数据
			while (((inputLine = reader.readLine()) != null)) {
				resultData.append(inputLine);
			}
			return resultData.toString();
			
		} catch (Exception e) {
			return "";
		}
	
	}
	
	/**
	 * 登录
	 * @param appContext
	 * @param username
	 * @param pwd
	 * @return
	 */
	public static ServerResponse login(Context appContext, String username, String pwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("pwd", pwd));				
		
		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.LOGIN_URL,params);
		
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	/**
	 * 注册
	 * @param appContext
	 * @param username
	 * @param pwd
	 * @return
	 */
	public static ServerResponse register(Context appContext, String username, String pwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("pwd", pwd));

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.REGISTER_URL,params);
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	/**
	 * 获取验证码
	 * @param phoneNumber
	 * @return
	 */
	public static ServerResponse getValidateCode(Context appContext,String phoneNumber)
	{

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.SEND_VALIDATECODE,phoneNumber));
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	/**
	 * 找回密码
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static ServerResponse findPassword(Context appContext,String username, String pwd)
	{

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("pwd", pwd));

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.REGISTER_URL,params);
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	/**
	 * 检查用户是否存在
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static ServerResponse checkUserAccount(Context appContext,String mobileNumber)
	{

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber));
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	/**
	 * 检查验证码是否正确
	 * @param appContext
	 * @param mobileNumber
	 * @param validateCode
	 * @return
	 */
	public static ServerResponse checkValidateCode(Context appContext,String mobileNumber,String validateCode)
	{

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber,validateCode));
		Gson gson = new Gson();
		ServerResponse resp = gson.fromJson(gson.toJson(res), ServerResponse.class);
	
		return resp;
	}
	
	public static ServerResponse getMembersContacts(Context appContext,String enterpriseId)
	{

		ServerResponse res = new ServerResponse();
		res.setCode(0);
		Result rt = new Result();
		res.setResult(rt);
		//{"code":0,"result":{"last_sync":1403180487257,"records":{"add":[]}}}
		String json = _httpget(MessageFormat.format(Constants.GET_MEMBERS_URL, "100009803012000300","1","0"));
		Gson gson = new Gson();
		ServerResponse resp = (ServerResponse)gson.fromJson(json, ServerResponse.class);
	
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
