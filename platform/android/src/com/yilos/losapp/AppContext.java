package com.yilos.losapp;


import com.yilos.losapp.api.ApiClient;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;

import android.app.Application;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	private int loginUid = 0;	//登录用户的id
	
	
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
	
	public ServerResponse loginVerify(String account, String pwd)  {
		
		return ApiClient.login(this, account, pwd);
	}
	
    public ServerResponse register(String account, String pwd)  {
		
		return ApiClient.register(this, account, pwd);
	}
	
    public ServerResponse getValidatecode(String phoneNumber)  {
		
		return ApiClient.getValidateCode(this, phoneNumber);
	}
    
    public ServerResponse checkValidatecode(String phoneNumber)  {
		
		return ApiClient.getValidateCode(this, phoneNumber);
	}
	
	/**
	 * 用户是否登录
	 * @return
	 */
	public boolean isLogin() {
		return login;
	}
}
