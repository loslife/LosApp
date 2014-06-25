package com.yilos.losapp;


import com.yilos.losapp.api.ApiClient;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;

import android.app.Application;
import android.content.Context;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	
	private String DBName;
	
	private String userAccount;
	
	private String currentDisplayShopId;
	
	private String lastSyncTime;
	
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
    public ServerResponse checkValidatecode(String phoneNumber,String checkType,String code)  {
		
		return ApiClient.checkValidateCode(this, phoneNumber, checkType,code);
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
    
    public ServerResponse modifyPwd(String phoneNumber,String pwd,String newpwd)
    {
    	return ApiClient.modifyUserPwd(this, phoneNumber,pwd,newpwd);
    }
    
    /**
     * 判断关联的店铺是否存在
     * @param phoneNumber
     * @return
     */
    public ServerResponse checkShopAccount(String phoneNumber)
    {
    	return ApiClient.checkShopAccount(this, phoneNumber);
    }
    
    /**
     * 获取通讯录
     * @param phoneNumber
     * @return
     */
    public ServerResponse getMembersContacts(String shopId,String lasSyncTime)
    {
    	return ApiClient.getMembersContacts(this, shopId,lasSyncTime);
    }
    
    /**
     * 获取关联的店铺
     * @param phoneNumber
     * @return
     */
    public ServerResponse getMyshopList(String phoneNumber)
    {
    	return ApiClient.getMyshopList(this, phoneNumber);
    }
    
    public ServerResponse linkshop(String userAccount,String shopAccount)
    {
    	return ApiClient.linkshop(appContext, userAccount, shopAccount);
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

	public String getUserAccount() {
		return userAccount;
	}

	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}

	public String getCurrentDisplayShopId() {
		return currentDisplayShopId;
	}

	public void setCurrentDisplayShopId(String currentDisplayShopId) {
		this.currentDisplayShopId = currentDisplayShopId;
	}

	public String getLastSyncTime() {
		
		return lastSyncTime;
	}

	public void setLastSyncTime(String lastSyncTime) {
		this.lastSyncTime = lastSyncTime;
	}
	
	
}
