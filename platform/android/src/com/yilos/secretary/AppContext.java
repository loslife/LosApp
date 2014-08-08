package com.yilos.secretary;


import com.yilos.secretary.api.ApiClient;
import com.yilos.secretary.bean.ServerManageResponse;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.bean.ServerVersionResponse;

import android.app.Application;
import android.content.Context;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	
	private String DBName;
	
	private String shopName;
	
	private String userAccount;
	
	private String currentDisplayShopId;
	
	private String contactLastSyncTime;
	
	private String reportLastSyncTime;
	
	private int loginUid = 0;	//登录用户的id
	
	public static AppContext appContext;
	
	private boolean  isFirstRun;
	
	private boolean  isChangeShop;
	
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
		
		return ApiClient.login(getApplicationContext(), account, pwd);
	}
	
	/**
	 * 注册
	 * @param account
	 * @param pwd
	 * @return
	 */
    public ServerMemberResponse register(String account, String pwd)  {
		
		return ApiClient.register(getApplicationContext(), account, pwd);
	}
    
    public ServerMemberResponse findPwd(String account, String pwd){
    	return ApiClient.findPassword(getApplicationContext(), account, pwd);
    }
	
    /**
     * 获取验证码
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getValidatecode(String phoneNumber,String codeTyep)  {
		
		return ApiClient.getValidateCode(getApplicationContext(), phoneNumber,codeTyep);
	}
    
    /**
     * 校验验证码
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkValidatecode(String phoneNumber,String checkType,String code)  {
		
		return ApiClient.checkValidateCode(getApplicationContext(), phoneNumber, checkType,code);
	}
    
    
    /**
     * 判断用户是否存在
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkUserAccount(String phoneNumber)
    {
    	return ApiClient.checkUserAccount(getApplicationContext(), phoneNumber);
    }
    
    public ServerMemberResponse modifyPwd(String phoneNumber,String pwd,String newpwd)
    {
    	return ApiClient.modifyUserPwd(getApplicationContext(), phoneNumber,pwd,newpwd);
    }
    
    /**
     * 判断关联的店铺是否存在
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse checkShopAccount(String phoneNumber)
    {
    	return ApiClient.checkShopAccount(getApplicationContext(), phoneNumber);
    }
    
    /**
     * 获取通讯录
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getMembersContacts(String shopId,String lasSyncTime)
    {
    	return ApiClient.getMembersContacts(getApplicationContext(), shopId,lasSyncTime);
    }
    
    /**
     * 获取店铺会员数量
     * @param shopId
     * @return
     */
    public ServerMemberResponse getMembersCount(String shopId)
    {
    	return ApiClient.getMembersCount(getApplicationContext(), shopId);
    }
    
    /**
     * 获取关联的店铺
     * @param phoneNumber
     * @return
     */
    public ServerMemberResponse getMyshopList(String phoneNumber)
    {
    	return ApiClient.getMyshopList(getApplicationContext(), phoneNumber);
    }
    
    /**
     * 关联店铺
     * @param userAccount
     * @param shopAccount
     * @return
     */
    public ServerMemberResponse linkshop(String userAccount,String shopAccount)
    {
    	return ApiClient.linkshop(getApplicationContext(), userAccount, shopAccount);
    }
    
    /**
     * 取消关联
     * @param userAccount
     * @param shopAccount
     * @return
     */
    public ServerMemberResponse undoLinkshop(String userAccount,String shopId)
    {
    	return ApiClient.undoLinkshop(getApplicationContext(), userAccount, shopId);
    }
    
    /**
     * @return 
     * 
     */
    public ServerManageResponse getReportsData(String shopid,String year,String month,String type,String day,String report)
    {
    	return ApiClient.getReports(getApplicationContext(), shopid,year, month, type, day, report);
    }
    
    /**
     * 检查版本
     */
    public ServerVersionResponse checkVersion(String version)
    {
    	return ApiClient.checkApkVersion(getApplicationContext(), version);
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

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public boolean isFirstRun() {
		return isFirstRun;
	}

	public void setFirstRun(boolean isFirstRun) {
		this.isFirstRun = isFirstRun;
	}

	public boolean isChangeShop() {
		return isChangeShop;
	}

	public void setChangeShop(boolean isChangeShop) {
		this.isChangeShop = isChangeShop;
	}
	
	
	
}
