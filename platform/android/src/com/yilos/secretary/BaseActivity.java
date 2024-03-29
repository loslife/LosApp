package com.yilos.secretary;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.Window;
import android.widget.Toast;

import com.yilos.secretary.common.ActivityControlUtil;

public class BaseActivity extends Activity
{
	/**
     * Context上下文
     */
    protected static Context mContext;
    
    boolean isExit; 
    
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        ActivityControlUtil.add(this);
        mContext = this;
    }
    
    Handler mHandler = new Handler() {  
    	  
        @Override  
        public void handleMessage(Message msg) {  
            super.handleMessage(msg);  
            isExit = false;  
        }  
  
    };  
    
    @Override
    public void onDestroy()
    {
        super.onDestroy();
    }
    
    /**
     * 跳转到Activity
     * 
     * @param clazz 目标Activity类名
     */
    private void startNewActivity(Class<?> clazz)
    {
        Intent intent = new Intent();
        intent.setClass(mContext, clazz);
        startActivity(intent);
    }
    
    
    
    /**
     * 退出系统
     */
    public void exit()
    {
    	if (!isExit) {  
            isExit = true;  
            Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();  
            mHandler.sendEmptyMessageDelayed(0, 2000);  
        } 
    	else
    	{
    		logout();
    	}
    }
    
    public void logout()
    {
    	//保存登出状态
    	AppContext.getInstance(getBaseContext()).setLogin(false);
        ActivityControlUtil.finishAllActivities();// finish所有Activity
        Intent logout = new Intent();
        logout.setClass(getBaseContext(), FirstActivity.class);
		startActivity(logout);
    }

}
