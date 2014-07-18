package com.yilos.losapp.api;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLEncoder;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.yilos.losapp.bean.ContactsResult;
import com.yilos.losapp.bean.ServerManageResponse;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.bean.ServerVersionResponse;
import com.yilos.losapp.common.Constants;
import com.yilos.losapp.common.LosSSLFactory;


import android.content.Context;
import android.os.Bundle;
import android.os.Message;

public class ApiClient 
{
	// 请求超时
    private static int connectionTimeout = 30000;
	// 读取超时
	private static int soTimeout = 50000;
	
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
			e.printStackTrace();
			return codeToJson("404");
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
			e.printStackTrace();
			return codeToJson("404");
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
			e.printStackTrace();
			return codeToJson("404");
		}
		finally
		{
			
		}
	}
	
	public static String _httppost(String url,List<NameValuePair> params)
	{

		StringBuilder resultData = new StringBuilder();
		try {
			HttpPost httppost = new HttpPost(url);
			httppost.setHeader("xhr", "true");
			httppost.setEntity(new UrlEncodedFormEntity(params));

			DefaultHttpClient httpClient = new DefaultHttpClient();
			// 请求超时
			httpClient.getParams().setParameter(
					CoreConnectionPNames.CONNECTION_TIMEOUT,
					connectionTimeout);
			// 读取超时
			httpClient.getParams().setParameter(
					CoreConnectionPNames.SO_TIMEOUT, soTimeout);
		
			HttpResponse httpResponse = httpClient.execute(httppost);

			BufferedReader reader = new BufferedReader(new InputStreamReader(
					httpResponse.getEntity().getContent()));
			String inputLine = null;
			// 使用循环来读取获得的数据
			while (((inputLine = reader.readLine()) != null)) {
				resultData.append(inputLine);
			}
			return resultData.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
			return codeToJson("404");
		}
	
	}
	
	/**
	 * 登录
	 * @param appContext
	 * @param username
	 * @param pwd
	 * @return
	 */
	public static ServerMemberResponse login(Context appContext, String username, String pwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("password", pwd));				
		
		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.LOGIN_URL,params);
		String json = _httppost(Constants.LOGIN_URL,params);
		
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 注册
	 * @param appContext
	 * @param username
	 * @param pwd
	 * @return
	 */
	public static ServerMemberResponse register(Context appContext, String username, String pwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("password", pwd));

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.REGISTER_URL,params);
		String json = _httppost(Constants.REGISTER_URL,params);
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	public static ServerMemberResponse modifyUserPwd(Context appContext, String username, String pwd,String newpwd) {

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("account", username));
		params.add(new BasicNameValuePair("old_password", pwd));
		params.add(new BasicNameValuePair("new_password", newpwd));

		//String json = _post(appContext, Constants.REGISTER_URL,params);
		String json = _httppost(Constants.MODIFYPWD_URL,params);
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 获取验证码
	 * @param phoneNumber
	 * @return
	 */
	public static ServerMemberResponse getValidateCode(Context appContext,String phoneNumber,String codeType)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _httpget(appContext, MessageFormat.format(Constants.SEND_VALIDATECODE,phoneNumber,"register_losapp"));
		String json = _httpget(MessageFormat.format(Constants.SEND_VALIDATECODE,phoneNumber,codeType));
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 找回密码
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static ServerMemberResponse findPassword(Context appContext,String username, String pwd)
	{

		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("username", username));
		params.add(new BasicNameValuePair("pwd", pwd));

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _post(appContext, Constants.REGISTER_URL,params);
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(gson.toJson(res), ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 检查用户是否存在
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static ServerMemberResponse checkUserAccount(Context appContext,String mobileNumber)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber));
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(gson.toJson(res), ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 检查用户是否存在
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static ServerMemberResponse checkShopAccount(Context appContext,String mobileNumber)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber));
		String json = _httpget(MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber));
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(gson.toJson(res), ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * 检查验证码是否正确
	 * @param appContext
	 * @param mobileNumber
	 * @param validateCode
	 * @return
	 */
	public static ServerMemberResponse checkValidateCode(Context appContext,String mobileNumber,String checkType,String validateCode)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		
		//String json = _get(appContext, MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber,validateCode));
		//CHECK_VALIDATECODE_SERVICE = "http://192.168.1.116:5000/svc/checkCode/{0}?u={1}&c={2}"
		String json = _httpget(MessageFormat.format(Constants.CHECK_VALIDATECODE_SERVICE, mobileNumber,checkType,validateCode));
		Gson gson = new Gson();
		ServerMemberResponse resp = gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	public static ServerMemberResponse getMembersContacts(Context appContext,String enterpriseId,String lasSyncTime)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		if(lasSyncTime==null)
		{
			lasSyncTime = "0";
		}
		BigDecimal time = new BigDecimal(lasSyncTime); 
		String json = _httpget(MessageFormat.format(Constants.GET_MEMBERS_URL, enterpriseId,"1",time.toPlainString()));
		Gson gson = new Gson();
		ServerMemberResponse resp = (ServerMemberResponse)gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	public static ServerMemberResponse getMyshopList(Context appContext,String phoneNumber)
	{

		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(0);
		ContactsResult rt = new ContactsResult();
		res.setResult(rt);
		//{"code":0,"result":{"last_sync":1403180487257,"records":{"add":[]}}}
		String json = _httpget(MessageFormat.format(Constants.GET_APPENDSHOP_RECORD, phoneNumber));
		Gson gson = new Gson();
		ServerMemberResponse resp = (ServerMemberResponse)gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	public static ServerMemberResponse linkshop(Context appContext,String username, String linkAccount)
	{
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair("account", username));
		params.add(new BasicNameValuePair("enterprise_account", linkAccount));

		//{"code":0,"result":{"last_sync":1403180487257,"records":{"add":[]}}}
		String json = _httppost(Constants.APPENDSHOP_URL,params);
		Gson gson = new Gson();
		ServerMemberResponse resp = (ServerMemberResponse)gson.fromJson(json, ServerMemberResponse.class);
	
		return resp;
	}
	
	/**
	 * http://192.168.1.108:5000/svc/report/probe/query/100043209618000500?year=2014&month=4&type=day&day=14&report=business
	 * @param appContext
	 * @return
	 */
	public static ServerManageResponse getReports(Context appContext,String shopid,String year,String month,String type,String day,String report)
	{
		String json = _httpget(MessageFormat.format(Constants.SYNCREPORTS_URL, shopid,year,month,day,type,report));
		Gson gson = new Gson();
		ServerManageResponse resp ;
		try
		{
			resp = gson.fromJson(json, ServerManageResponse.class);
		}catch(JsonSyntaxException e)
		{
			e.printStackTrace();
			resp =null;
		}
		
		
		return resp;
	}
	
	public static ServerVersionResponse checkApkVersion(Context appContext,String version)
	{
		String json = _httpget(MessageFormat.format(Constants.CHECKNEWVERSION_URL, version));
		Gson gson = new Gson();
		ServerVersionResponse resp ;
		try
		{
			resp = gson.fromJson(json, ServerVersionResponse.class);
		}catch(JsonSyntaxException e)
		{
			e.printStackTrace();
			resp =null;
		}
		
		
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
	
	private static String codeToJson(String code)
	{
		ServerMemberResponse res = new ServerMemberResponse();
		res.setCode(1);
		ContactsResult rt = new ContactsResult();
		rt.setErrorCode(code);
		res.setResult(rt);
		Gson gson = new Gson();
		return gson.toJson(res);
	}
	
}
