package com.yilos.losapp.common;

import java.io.File;

import android.os.Environment;

public class Constants 
{
	public static final String SERVICE_IP = "www.yilos.com";
	
	public static final String HTTPS_SERVICE_ADDRESS = "https://" + SERVICE_IP
			+ "/svc/";
	public static final String LOGIN_URL = "";
	
	public static final String REGISTER_URL = "";
	
	public static final String SD_PATH = Environment.getExternalStorageDirectory().getAbsolutePath();
	
	public static final String YILOS_SDPATH = SD_PATH+File.separator+"yilos/losapp/";
	
	/**
	 * 发送验证码
	 */
	public static final String SEND_VALIDATECODE = HTTPS_SERVICE_ADDRESS
			+ "nail/sendValidateCode?username={0}";
	
	/**
	 * 检查验证码
	 */
	public static final String CHECK_VALIDATECODE_SERVICE = HTTPS_SERVICE_ADDRESS
			+ "nail/checkValidateCode?username={0}&validateCode={1}";
	
	/**
	 * 获取会员通讯录
	 */
	public static final String GET_MEMBERS_URL = "http://" + "192.168.1.104:5000"
			+ "/svc/"
			+ "losapp/syncMembers/{0}?v={1}&t={2}";

}
