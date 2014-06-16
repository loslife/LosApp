package com.yilos.losapp.common;

public class Constants 
{
	public static final String SERVICE_IP = "www.yilos.com";
	
	public static final String HTTPS_SERVICE_ADDRESS = "https://" + SERVICE_IP
			+ "/svc/";
	public static final String LOGIN_URL = "";
	
	public static final String REGISTER_URL = "";
	
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

}
