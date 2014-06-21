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
	
	//http://192.168.1.104:5000/svc/checkCode/15019432710?u=register&c=200957
	//http://192.168.1.104:5000/svc/getCode/15019432710?u=attach
	//var LEGAL_USAGE = ["attach", "register", "reset_password", "register_losapp"];
	//http://192.168.1.104:5000/svc/losapp/attachEnterprises/15019432710  查找
	//http://192.168.1.104:5000/svc/losapp/appendEnterprise  关联
	//http://192.168.1.114:5000/svc/losapp/syncMembers/100009803012000300?v=1&t=0
	///svc/losapp/login
	///svc/losapp/register
	
	// 88888401，请求参数错误
	// 88888500，数据库访问错误
	// 88888501，验证码不存在
	// 88888502，验证码不匹配
	// 8888850x，数据库访问错误
	// 88888601，发送短信失败
	
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
	public static final String GET_MEMBERS_URL = "http://" + "192.168.1.112:5000"
			+ "/svc/"
			+ "losapp/syncMembers/{0}?v={1}&t={2}";

}
