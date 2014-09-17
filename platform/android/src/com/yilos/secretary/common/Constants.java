package com.yilos.secretary.common;

import java.io.File;

import android.os.Environment;

public class Constants 
{
	public static final String SERVICE_IP = "121.40.75.73"; //"42.121.255.30" "112.124.28.115";//"www.yilos.com";"121.40.75.73"
	
	public static final String HTTPS_SERVICE_ADDRESS = "https://" + SERVICE_IP
			+ "/svc/";
	
	public static final String SD_PATH = Environment.getExternalStorageDirectory().getAbsolutePath();
	
	public static final String YILOS_SDPATH = SD_PATH+File.separator+"yilos/losapp/";
	
	public static final String YILOS_NAILSHOP_LOGPATH = YILOS_SDPATH+"/log/";
	
	public static final String FILE_SUFFIX_ZIP = ".zip";
	
	public static final long ONE_MB_SIZE = 1024L * 1024;
	
	public static final String VERSION = "1";
	
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
	
	
	public static final String SERVICE_ADDRESS = "http://" + SERVICE_IP
			+ "/svc/";
	
	/**
	 * 日志文件上传服务
	 */
	public static final String LOGGER_UPLOAD_SERVICE = HTTPS_SERVICE_ADDRESS
			+ "upload/logger-upload";
	
	/**
	 * 获取验证码
	 */
	public static final String SEND_VALIDATECODE = "https://"+SERVICE_IP+"/svc/getCode/{0}?u={1}";
	
	/**
	 * 检查验证码
	 */
	public static final String CHECK_VALIDATECODE_SERVICE = "https://"+SERVICE_IP+"/svc/checkCode/{0}?u={1}&c={2}";
	
	/**
	 * 检查店铺的账号
	 */
	public static final String CHECHSHOPUSER_SERVICE = "https://"+SERVICE_IP+"/svc/"
			+ "oauth/login/checkUser?username=";
	
	/**
	 * 注册
	 */
	public static final String REGISTER_URL = "https://" +SERVICE_IP
			+ "/svc/losapp/register";
	
	/**
	 * 登录
	 */
	public static final String LOGIN_URL ="https://" +SERVICE_IP
			+ "/svc/losapp/login";
	
	/**
	 * 修改密码
	 */
	public static final String MODIFYPWD_URL ="https://"+SERVICE_IP
			+ "/svc/losapp/modifyPassword";
	
	/**
	 * 找回密码
	 */
	public static final String FINDPWD_URL ="https://"+SERVICE_IP
	+"/svc/losapp/resetPassword";
	
	/**
	 * 获取会员通讯录
	 */
	public static final String GET_MEMBERS_URL = "https://" +SERVICE_IP
			+ "/svc/"
			+ "losapp/syncMembers/{0}?v={1}&t={2}";
	
	/**
	 * 获取会员的数量
	 */
	public static final String GET_MEMBERS_COUNT = "https://"+SERVICE_IP+"/svc/losapp/countMembers/{0}";
	
	/**
	 * 查询已关联的店铺
	 */
	public static final String GET_APPENDSHOP_RECORD = "https://"+SERVICE_IP+"/svc/losapp/attachEnterprises/{0}";
	
	/**
	 * 关联店铺
	 */
	public static final String APPENDSHOP_URL = "https://"+SERVICE_IP+"/svc/losapp/appendEnterprise";
	
	/**
	 * 取消关联
	 */
	public static final String UNDOAPPENDSHOP_URL = "https://"+SERVICE_IP+"/svc/losapp/undoAppendEnterprise";
	
	/**
	 * 
	 */
	public static final String CHECKNEWVERSION_URL = "https://"+SERVICE_IP+"/svc/losapp/checkNewVersion/{0}";

	
	/**
	 * 同步经营数据
	 */
	public static final String SYNCREPORTS_URL = "https://"+SERVICE_IP+"/svc/report/probe/query/{0}?year={1}&month={2}&day={3}&type={4}";
	
	

}
