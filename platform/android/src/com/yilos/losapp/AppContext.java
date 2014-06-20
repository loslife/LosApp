package com.yilos.losapp;


import com.yilos.losapp.api.ApiClient;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;

import android.app.Application;
import android.content.Context;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	
	private String DBName;
	
	private int loginUid = 0;	//登录用户的id
	
	public static AppContext appContext;
	
	@Override
	public void onCreate() {
		super.onCreate(); 
        init();
	}

	/**
	 * 初始化
	 */
	private void init(){

	}
	
	 public static synchronized AppContext getInstance(Context ctx)
	    {
	        if (null == appContext)
	        {
	        	appContext = new AppContext();
	        }
	        return appContext;
	    }
	
	/**
	 * 登录验证
	 * @param account
	 * @param pwd
	 * @return
	 */
	public ServerResponse loginVerify(String account, String pwd)  {
		
		return ApiClient.login(this, account, pwd);
	}
	
	/**
	 * 注册
	 * @param account
	 * @param pwd
	 * @return
	 */
    public ServerResponse register(String account, String pwd)  {
		
		return ApiClient.register(this, account, pwd);
	}
	
    /**
     * 获取验证码
     * @param phoneNumber
     * @return
     */
    public ServerResponse getValidatecode(String phoneNumber)  {
		
		return ApiClient.getValidateCode(this, phoneNumber);
	}
    
    /**
     * 校验验证码
     * @param phoneNumber
     * @return
     */
    public ServerResponse checkValidatecode(String phoneNumber,String code)  {
		
		return ApiClient.checkValidateCode(this, phoneNumber, code);
	}
    
    
    /**
     * 判断用户是否存在
     * @param phoneNumber
     * @return
     */
    public ServerResponse checkUserAccount(String phoneNumber)
    {
    	return ApiClient.checkUserAccount(this, phoneNumber);
    }
    
    /**
     * 获取通讯录
     * @param phoneNumber
     * @return
     */
    public ServerResponse getMembersContacts(String phoneNumber)
    {
    	return ApiClient.getMembersContacts(this, "");
    }
	
	/**
	 * 用户是否登录
	 * @return
	 */
	public boolean isLogin() {
		return login;
	}
	
	public void setLogin(boolean islogin) {
		this.login = islogin;
	}

	public String getDBName() {
		return DBName;
	}

	public void setDBName(String dBName) {
		DBName = dBName;
	}
	
	
}
