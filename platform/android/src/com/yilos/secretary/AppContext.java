package com.yilos.secretary;


import java.util.Properties;

import com.yilos.secretary.api.ApiClient;
import com.yilos.secretary.api.AppConfig;
import com.yilos.secretary.bean.ServerManageResponse;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.bean.ServerVersionResponse;
import com.yilos.secretary.common.ActivityControlUtil;
import com.yilos.secretary.common.CrashHandler;
import com.yilos.secretary.common.UIHelper;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Looper;
import android.widget.Toast;

public class AppContext extends Application{
	
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
	
	private boolean isChangeContact;
	
	private static SharedPreferences preferences;  
	
	
	@Override
	public void onCreate() {
		super.onCreate(); 
        init();
        
        CrashHandler crashHandler = CrashHandler.getInstance();  
        crashHandler.init(getApplicationContext()); 
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
	        preferences =ctx.getApplicationContext().getSharedPreferences("userinfo",0);  
	        return appContext;
	    }
	 /*
		public void uncaughtException(Thread thread, Throwable ex) {
			//保存登出状态
			handleException(ex);
	    	AppContext.getInstance(getBaseContext()).setLogin(false);
	        ActivityControlUtil.finishAllActivities();// finish所有Activity
			System.exit(0);
			Intent intent = new Intent(this, LoginActivity.class);
			intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
			Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.putExtra("exceptionLogout", "yes");
			startActivity(intent);
		}
		*/
		
	
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
		login = "1".equals(getProperty("islogin"))?true:false; 
		return login;
	}
	
	public void setLogin(boolean islogin) {
        String flag = "0";
        if(islogin)
        {
        	flag = "1";
        }
		setProperty("islogin", flag); 
		this.login = islogin;
	}

	public String getDBName() {
		DBName=getProperty("dBName");  
		return DBName;
	}

	public void setDBName(String dBName) {
		setProperty("dBName", dBName);  
		DBName = dBName;
	}

	public String getUserAccount() {  
		userAccount=getProperty("userAccount");  
		return userAccount;
	}

	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
		 setProperty("userAccount", userAccount);  
	}

	public String getCurrentDisplayShopId() {
		currentDisplayShopId=getProperty("shoip");  
		if(null == currentDisplayShopId)
		{
			currentDisplayShopId = "";
		}
		return currentDisplayShopId;
	}

	public void setCurrentDisplayShopId(String currentDisplayShopId) {
		this.currentDisplayShopId = currentDisplayShopId;
		 setProperty("shoip", currentDisplayShopId);  
	}

	public String getContactLastSyncTime() {
		contactLastSyncTime=getProperty("contactLastSyncTime");
		return contactLastSyncTime;
	}

	public void setContactLastSyncTime(String contactLastSyncTime) {
		setProperty("contactLastSyncTime", contactLastSyncTime);  
		this.contactLastSyncTime = contactLastSyncTime;
	}

	public String getReportLastSyncTime() {
		reportLastSyncTime=getProperty("reportLastSyncTime");
		return reportLastSyncTime;
	}

	public void setReportLastSyncTime(String reportLastSyncTime) {
		setProperty("reportLastSyncTime", reportLastSyncTime);  
		this.reportLastSyncTime = reportLastSyncTime;
	}

	public String getShopName() {
		shopName=getProperty("shopName");
		return shopName;
	}

	public void setShopName(String shopName) {
		setProperty("shopName", shopName);  
		this.shopName = shopName;
	}

	public boolean isFirstRun() {
		isFirstRun = "1".equals(getProperty("isFirstRun"))?true:false; 
		return isFirstRun;
	}

	public void setFirstRun(boolean isFirstRun) {
		 String flag = "0";
	        if(isFirstRun)
	        {
	        	flag = "1";
	        }
	    setProperty("isFirstRun", flag); 
		this.isFirstRun = isFirstRun;
	}

	public boolean isChangeShop() {
		isChangeShop = "1".equals(getProperty("isChangeShop"))?true:false; 
		return isChangeShop;
	}

	public void setChangeShop(boolean isChangeShop) {
        String flag = "0";
        if(isChangeShop)
        {
        	flag = "1";
        }
		setProperty("isChangeShop", flag);  

		this.isChangeShop = isChangeShop;
	}
	
	
	

	public boolean isChangeContact() {
		isChangeContact = "1".equals(getProperty("isChangeContact"))?true:false; 
		return isChangeContact;
	}

	public void setChangeContact(boolean isChangeContact) {
		    String flag = "0";
	        if(isChangeContact)
	        {
	        	flag = "1";
	        }
			setProperty("isChangeContact", flag);  
			this.isChangeContact = isChangeShop;
	}

	public void setProperties(Properties ps){
		AppConfig.getAppConfig(this).set(ps);
	}

	public Properties getProperties(){
		return AppConfig.getAppConfig(this).get();
	}
	
	public void setProperty(String key,String value){
		if(null!=value)
		{
			AppConfig.getAppConfig(this).set(key, value);
		}
	}
	
	public String getProperty(String key){
		return AppConfig.getAppConfig(this).get(key);
	}
	public void removeProperty(String...key){
		AppConfig.getAppConfig(this).remove(key);
	}
}
