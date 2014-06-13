package com.yilos.losapp;


import com.yilos.losapp.api.ApiClient;

import android.app.Application;

public class AppContext extends Application {
	
	private boolean login = false;	//登录状态
	private int loginUid = 0;	//登录用户的id
	
	
	@Override
	public void onCreate() {
		super.onCreate();
        //注册App异常崩溃处理器
        
        init();
	}

	/**
	 * 初始化
	 */
	private void init(){

	}
	
	public String loginVerify(String account, String pwd)  {
		/*{
			  "code" : 0,
			  result:{
				“message" : "ok"
			  }
			}*/
		return ApiClient.login(this, account, pwd);
	}
	
	
	/**
	 * 用户是否登录
	 * @return
	 */
	public boolean isLogin() {
		return login;
	}
}
