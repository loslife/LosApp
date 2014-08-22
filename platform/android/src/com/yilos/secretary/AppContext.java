package com.yilos.secretary;


import com.yilos.secretary.api.ApiClient;
import com.yilos.secretary.bean.ServerManageResponse;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.bean.ServerVersionResponse;
import com.yilos.secretary.common.ActivityControlUtil;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.exception.CrashHandler;

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
	
	private static SharedPreferences preferences;  
	
	
	@Override
	public void onCreate() {
		super.onCreate(); 
        init();
        //设置Thread Exception Handler
      	//Thread.setDefaultUncaughtExceptionHandler(this);
        
        /*CrashHandler crashHandler = CrashHandler.getInstance();  
        crashHandler.init(getApplicationContext()); */
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
		login = preferences.getBoolean("islogin", false); 
		return login;
	}
	
	public void setLogin(boolean islogin) {
		Editor edit=preferences.edit();  
        edit.putBoolean("islogin", islogin);  
        edit.commit();
		this.login = islogin;
	}

	public String getDBName() {
		DBName=preferences.getString("dBName", "");  
		return DBName;
	}

	public void setDBName(String dBName) {
		Editor edit=preferences.edit();  
        edit.putString("dBName", dBName);  
        edit.commit(); 
		DBName = dBName;
	}

	public String getUserAccount() {  
		userAccount=preferences.getString("userAccount", "");  
		return userAccount;
	}

	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
		 Editor edit=preferences.edit();  
         edit.putString("userAccount", userAccount);  
         edit.commit(); 
	}

	public String getCurrentDisplayShopId() {
		currentDisplayShopId=preferences.getString("shoip", "");  
		return currentDisplayShopId;
	}

	public void setCurrentDisplayShopId(String currentDisplayShopId) {
		this.currentDisplayShopId = currentDisplayShopId;
		
		 Editor edit=preferences.edit();  
         edit.putString("shoip", currentDisplayShopId);  
         edit.commit(); 
	}

	public String getContactLastSyncTime() {
		contactLastSyncTime=preferences.getString("contactLastSyncTime", "");
		return contactLastSyncTime;
	}

	public void setContactLastSyncTime(String contactLastSyncTime) {
		Editor edit=preferences.edit();  
        edit.putString("contactLastSyncTime", contactLastSyncTime);  
        edit.commit(); 
		this.contactLastSyncTime = contactLastSyncTime;
	}

	public String getReportLastSyncTime() {
		reportLastSyncTime=preferences.getString("reportLastSyncTime", "");
		return reportLastSyncTime;
	}

	public void setReportLastSyncTime(String reportLastSyncTime) {
		Editor edit=preferences.edit();  
        edit.putString("reportLastSyncTime", reportLastSyncTime);  
        edit.commit(); 
		this.reportLastSyncTime = reportLastSyncTime;
	}

	public String getShopName() {
		shopName=preferences.getString("shopName", "");
		return shopName;
	}

	public void setShopName(String shopName) {
		Editor edit=preferences.edit();  
        edit.putString("shopName", shopName);  
        edit.commit(); 
		this.shopName = shopName;
	}

	public boolean isFirstRun() {
		return isFirstRun;
	}

	public void setFirstRun(boolean isFirstRun) {
		this.isFirstRun = isFirstRun;
	}

	public boolean isChangeShop() {
		isChangeShop = preferences.getBoolean("isChangeShop", false); 
		return isChangeShop;
	}

	public void setChangeShop(boolean isChangeShop) {
		Editor edit=preferences.edit();  
        edit.putBoolean("isChangeShop", isChangeShop);  
        edit.commit();
		this.isChangeShop = isChangeShop;
	}
	
	
	
}
