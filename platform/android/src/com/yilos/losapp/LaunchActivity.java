package com.yilos.losapp;

import java.util.List;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.database.SDBHelper;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

public class LaunchActivity extends Activity {  
	
    private MemberService memberService;
	
	private MyshopManageService myshopService;
	
	private String shopName;
  
    @Override  
    protected void onCreate(Bundle savedInstanceState) {  
        super.onCreate(savedInstanceState);  
        setContentView(R.layout.launch);  
        Handler x = new Handler();//定义一个handle对象   
        
        boolean isLogin = AppContext.getInstance(getBaseContext()).isLogin();
        
        
        if(isLogin)
        {
        	 startActivity(new Intent(getApplication(),MainTabActivity.class));// 这个线程的作用3秒后就是进入到你的主界面  
             LaunchActivity.this.finish();// 把当前的LaunchActivity结束掉  
        }
        else
        {
        	x.postDelayed(new splashhandler(), 3000);
        }
          
    }  
  
    class splashhandler implements Runnable{  
        public void run() {
        	
        	//创建数据库
        	String userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
        	SDBHelper.createDB(LaunchActivity.this, userAccount+".db");
        	
        	//获取初始数据
        	AppContext ac = (AppContext)getApplication();
        	memberService = new MemberService(getBaseContext());
    		myshopService = new MyshopManageService(getBaseContext());
        	 List<MyShopBean> myshops = myshopService.queryShops();
			 if(myshops == null||myshops.size()==0)
			 {
				 ServerResponse res = ac.getMyshopList(userAccount);
				 if(res.isSucess())
					{
						myshopService.addShops(res.getResult().getMyShopList());
						myshops = myshopService.queryShops();
					}
			 }
			 if(myshops!= null&&myshops.size()>0)
			 {
				 String shopId = myshops.get(0).getEnterprise_id();
				 String last_sync = myshops.get(0).getLatest_sync();
				 shopName = myshops.get(0).getEnterprise_name();
				 ServerResponse res = ac.getMembersContacts(shopId,last_sync);
				 if(res.isSucess())
				 {
						memberService.handleMembers(res.getResult().getRecords());
						last_sync = String.valueOf(res.getResult().getLast_sync());
						myshopService.updateLatestSync(last_sync, shopId, "Contacts");
						AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
						AppContext.getInstance(getBaseContext()).setContactLastSyncTime(last_sync);
				 }
				  
			 }
			 else
			 {
				 shopName = "";
			 }
			Intent mainIntent = new Intent();
			mainIntent.setClass(getApplication(),MainTabActivity.class);
			mainIntent.putExtra("shopName", shopName);
            startActivity(mainIntent);
            LaunchActivity.this.finish();
        }  
    }  
      
   
  
}  
