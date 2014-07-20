package com.yilos.losapp;


import com.yilos.losapp.api.ApiClient;
import com.yilos.losapp.bean.ServerManageResponse;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.bean.ServerVersionResponse;

import android.app.Application;
import android.content.Context;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	
	private String DBName;
	
	private String userAccount;
	
	private String currentDisplayShopId;
	
	private String contactLastSyncTime;
	
	private String reportLastSyncTime;
	
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
	public ServerMemberResponse loginVerify(String account, String pwd)  {
		
		return ApiClient.login(this, account, pwd);
	}
	
	/**
	 * 注册
	 * @param account
	 * @param pwd
	 * @return
	 */
    public ServerMemberResponse register(String account, String pwd)  {
		
		return ApiClient.register(this, account, pwd);
	}
    
    public ServerMemberResponse findPwd(String account, String pwd){
    	return ApiClient.findPassword(this, account, pwd);
    }
	
    /**
     * 获取验证码
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getValidatecode(String phoneNumber,String codeTyep)  {
		
		return ApiClient.getValidateCode(this, phoneNumber,codeTyep);
	}
    
    /**
     * 校验验证码
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkValidatecode(String phoneNumber,String checkType,String code)  {
		
		return ApiClient.checkValidateCode(this, phoneNumber, checkType,code);
	}
    
    
    /**
     * 判断用户是否存在
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkUserAccount(String phoneNumber)
    {
    	return ApiClient.checkUserAccount(this, phoneNumber);
    }
    
    public ServerMemberResponse modifyPwd(String phoneNumber,String pwd,String newpwd)
    {
    	return ApiClient.modifyUserPwd(this, phoneNumber,pwd,newpwd);
    }
    
    /**
     * 判断关联的店铺是否存在
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkShopAccount(String phoneNumber)
    {
    	return ApiClient.checkShopAccount(this, phoneNumber);
    }
    
    /**
     * 获取通讯录
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getMembersContacts(String shopId,String lasSyncTime)
    {
    	return ApiClient.getMembersContacts(this, shopId,lasSyncTime);
    }
    
    /**
     * 获取店铺会员数量
     * @param shopId
     * @return
     */
    public ServerMemberResponse getMembersCount(String shopId)
    {
    	return ApiClient.getMembersCount(this, shopId);
    }
    
    /**
     * 获取关联的店铺
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getMyshopList(String phoneNumber)
    {
    	return ApiClient.getMyshopList(this, phoneNumber);
    }
    
    /**
     * 关联店铺
     * @param userAccount
     * @param shopAccount
     * @return
     */
    public ServerMemberResponse linkshop(String userAccount,String shopAccount)
    {
    	return ApiClient.linkshop(appContext, userAccount, shopAccount);
    }
    
    /**
     * 取消关联
     * @param userAccount
     * @param shopAccount
     * @return
     */
    public ServerMemberResponse undoLinkshop(String userAccount,String shopAccount)
    {
    	return ApiClient.undoLinkshop(appContext, userAccount, shopAccount);
    }
    
    /**
     * @return 
     * 
     */
    public ServerManageResponse getReportsData(String shopid,String year,String month,String type,String day,String report)
    {
    	return ApiClient.getReports(appContext, shopid,year, month, type, day, report);
    }
    
    /**
     * 检查版本
     */
    public ServerVersionResponse checkVersion(String version)
    {
    	return ApiClient.checkApkVersion(appContext, version);
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

	public String getContactLastSyncTime() {
		return contactLastSyncTime;
	}

	public void setContactLastSyncTime(String contactLastSyncTime) {
		this.contactLastSyncTime = contactLastSyncTime;
	}

	public String getReportLastSyncTime() {
		return reportLastSyncTime;
	}

	public void setReportLastSyncTime(String reportLastSyncTime) {
		this.reportLastSyncTime = reportLastSyncTime;
	}
	
}
