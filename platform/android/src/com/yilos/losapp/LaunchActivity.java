package com.yilos.losapp;

import java.util.List;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.database.SDBHelper;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

public class LaunchActivity extends Activity {

	private MemberService memberService;

	private MyshopManageService myshopService;

	private String shopName;

	String userAccount;

	String shopId;
	String last_sync;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.launch);
		Handler x = new Handler();// 定义一个handle对象
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		boolean isLogin = AppContext.getInstance(getBaseContext()).isLogin();
		if(true)
		{
			toMain();
		}

		initdata(); 
	}

	final Handler handle = new Handler() {
		public void handleMessage(Message msg) {
			if (msg.what == 1) {
				getMemberContact();
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

	public void initdata() {
		// 创建数据库
		String userAccount = AppContext.getInstance(getBaseContext())
				.getUserAccount();
		SDBHelper.createDB(LaunchActivity.this, userAccount + ".db");
		memberService = new MemberService(getBaseContext());
		myshopService = new MyshopManageService(getBaseContext());
		
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops == null || myshops.size() == 0) {
			getLinkShop();
		}
		if (myshops != null && myshops.size() > 0) {
			shopId = myshops.get(0).getEnterprise_id();
			last_sync = myshops.get(0).getContactSyncTime();
			shopName = myshops.get(0).getEnterprise_name();
			getMemberContact();
		}
	}

	
	public void toMain()
	{
		Intent mainIntent = new Intent();
		mainIntent.setClass(getApplication(), MainTabActivity.class);
		mainIntent.putExtra("shopName", shopName);
		startActivity(mainIntent);
		LaunchActivity.this.finish();
	}

	public void getLinkShop() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerResponse res = ac.getMyshopList(userAccount);
				if (res.isSucess()) {
					myshopService.addShops(res.getResult().getMyShopList());
					List<MyShopBean> myshops = myshopService.queryShops();
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

	public void getMemberContact() {

		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();

				ServerResponse res = ac.getMembersContacts(shopId, last_sync);
				if (res.isSucess()) {
					AppContext.getInstance(getBaseContext())
					.setCurrentDisplayShopId(shopId);
					memberService.handleMembers(res.getResult().getRecords());
					last_sync = String.valueOf(res.getResult().getLast_sync());
					myshopService.updateLatestSync(last_sync, shopId,
							"Contacts");
					AppContext.getInstance(getBaseContext())
							.setContactLastSyncTime(last_sync);
					msg.what = 3;
				}
				if (res.getCode() == 1) {
					msg.what = 0;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

}
