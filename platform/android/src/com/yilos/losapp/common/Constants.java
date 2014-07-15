package com.yilos.losapp.common;

import java.io.File;

import android.os.Environment;

public class Constants 
{
	public static final String SERVICE_IP = "www.yilos.com";
	
	public static final String HTTPS_SERVICE_ADDRESS = "https://" + SERVICE_IP
			+ "/svc/";
	
	public static final String SD_PATH = Environment.getExternalStorageDirectory().getAbsolutePath();
	
	public static final String YILOS_SDPATH = SD_PATH+File.separator+"yilos/losapp/";
	
	//http://192.168.1.104:5000/svc/checkCode/15019432710?u=register&c=200957
	//http://192.168.1.104:5000/svc/getCode/15019432710?u=attach
	//var LEGAL_USAGE = ["attach", "register", "reset_password", "register_losapp"];
	//http://192.168.1.104:5000/svc/losapp/attachEnterprises/15019432710  查找
	//http://192.168.1.104:5000/svc/losapp/appendEnterprise  关联
	//http://192.168.1.114:5000/svc/losapp/syncMembers/100009803012000300?v=1&t=0
	//http://192.168.1.115:5000/svc/report/probe/query/100048101900800200?year=2014@&month=6&day=24&type=day&report=employee
	
	
	///svc/losapp/login
	///svc/losapp/register
	///losapp/modifyPassword
	// 88888401，请求参数错误
	// 88888500，数据库访问错误
	// 88888501，验证码不存在
	// 88888502，验证码不匹配
	// 8888850x，数据库访问错误
	// 88888601，发送短信失败
	
	/**
	 * 获取验证码
	 */
	public static final String SEND_VALIDATECODE = "http://192.168.1.122:5000/svc/getCode/{0}?u={1}";
	
	/**
	 * 检查验证码
	 */
	public static final String CHECK_VALIDATECODE_SERVICE = "http://192.168.1.122:5000/svc/checkCode/{0}?u={1}&c={2}";
	
	/**
	 * 检查店铺的账号
	 */
	public static final String CHECHSHOPUSER_SERVICE = "http://192.168.1.122:5000/svc/"
			+ "oauth/login/checkUser?username=";
	
	/**
	 * 注册
	 */
	public static final String REGISTER_URL = "http://" + "192.168.1.122:5000"
			+ "/svc/losapp/register";
	
	/**
	 * 登录
	 */
	public static final String LOGIN_URL ="http://" + "192.168.1.122:5000"
			+ "/svc/losapp/login";
	
	/**
	 * 修改密码
	 */
	public static final String MODIFYPWD_URL ="http://" + "192.168.1.122:5000"
			+ "/svc/losapp/modifyPassword";
	
	/**
	 * 获取会员通讯录
	 */
	public static final String GET_MEMBERS_URL = "http://" + "192.168.1.122:5000"
			+ "/svc/"
			+ "losapp/syncMembers/{0}?v={1}&t={2}";
	
	/**
	 * 查询已关联的店铺
	 */
	public static final String GET_APPENDSHOP_RECORD = "http://192.168.1.122:5000/svc/losapp/attachEnterprises/{0}";
	
	/**
	 * 关联店铺
	 */
	public static final String APPENDSHOP_URL = "http://192.168.1.122:5000/svc/losapp/appendEnterprise";
	
	/**
	 * 同步经营数据
	 */
	public static final String SYNCREPORTS_URL = "http://192.168.1.122:5000/svc/report/probe/query/{0}?year={1}&month={2}&day={3}&type={4}&report={5}";
	
	

}
