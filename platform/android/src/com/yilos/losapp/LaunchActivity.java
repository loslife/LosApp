package com.yilos.losapp;

import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.database.SDBHelper;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

public class LaunchActivity extends Activity {

	private MemberService memberService;

	private MyshopManageService myshopService;

	private String shopName;

	private String userAccount;

	private String shopId;
	private String last_sync = "0";
	private List<MyShopBean> myshops;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.launch);
		Handler x = new Handler();// 定义一个handle对象
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		
		initdata(); 

	}

	final Handler handle = new Handler() {
		
		public void handleMessage(Message msg) {
			
			boolean isLogin = AppContext.getInstance(getBaseContext()).isLogin();
			if(isLogin)
			{
				toMain();
			}
			else
			{
				// 未登录，跳转到登录页面
                Intent intent = new Intent(LaunchActivity.this, LoginActivity.class);
                startActivity(intent);
			}
			
			if (msg.what == 1) {
				List<MyShopBean> myshops = myshopService.queryShops();
				for(int i=0;i<myshops.size();i++)
				{
					getMemberContact(myshops.get(i).getEnterprise_id(),myshops.get(i).getContactSyncTime());	
				}
			}
			if (msg.what == 2||msg.what == 3) {
				UIHelper.ToastMessage(getBaseContext(), "登录成功");
				AppContext.getInstance(getBaseContext()).setLogin(true);
				toMain();
			}
			if (msg.what == 0) {
				UIHelper.ToastMessage(LaunchActivity.this, "初始化数据失败");
			}
		}

	};

	/**
	 * 初始化数据
	 */
	public void initdata() {
		// 创建数据库
		String userAccount = AppContext.getInstance(getBaseContext())
				.getUserAccount();
		SDBHelper.createDB(LaunchActivity.this, userAccount + ".db");
		memberService = new MemberService(getBaseContext());
		myshopService = new MyshopManageService(getBaseContext());
		
		myshops = myshopService.queryShops();
		if (myshops == null || myshops.size() == 0) {
			getLinkShop();
		}
		if (myshops != null && myshops.size() > 0) {
			shopId = myshops.get(0).getEnterprise_id();
			shopName = myshops.get(0).getEnterprise_name();
			for(int i=0;i<myshops.size();i++)
			{
				
				getMemberContact(myshops.get(i).getEnterprise_id(),myshops.get(i).getContactSyncTime());	
			}
			
		}
	}

	/**
	 * 进到主界面
	 */
	public void toMain()
	{
		Intent mainIntent = new Intent();
		mainIntent.setClass(getApplication(), MainTabActivity.class);
		mainIntent.putExtra("shopName", shopName);
		startActivity(mainIntent);
		LaunchActivity.this.finish();
	}

	/**
	 * 获取关联的店铺
	 */
	public void getLinkShop() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerMemberResponse res = ac.getMyshopList(userAccount);
				if (res.isSucess()) {
					myshopService.addShops(res.getResult().getMyShopList());
					myshops = myshopService.queryShops();
					if (myshops != null && myshops.size() > 0) {
						shopId = myshops.get(0).getEnterprise_id();
						last_sync = myshops.get(0).getContactSyncTime();
						shopName = myshops.get(0).getEnterprise_name();
						msg.what = 1;
					} else {
						shopName = "";
						msg.what = 2;
					}
				}
				if (res.getCode() == 1) {
					msg.what = 0;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

	/**
	 * 获取会员通讯录
	 * @param linkshopId
	 */
	public void getMemberContact(final String linkshopId,final String lasSync) {

		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();

				ServerMemberResponse res = ac.getMembersContacts(linkshopId, lasSync);
				if (res.isSucess()) {
					memberService.handleMembers(res.getResult().getRecords());
					last_sync = String.valueOf(res.getResult().getLast_sync());
					myshopService.updateLatestSync(last_sync, linkshopId,
							"Contacts");
					AppContext.getInstance(getBaseContext())
							.setContactLastSyncTime(last_sync);
					if(linkshopId.equals(myshops.get(myshops.size()-1)));
					{
						msg.what = 3;
					}
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

}
