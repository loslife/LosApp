package com.yilos.secretary;

import java.util.List;

import org.apache.log4j.Logger;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.LinearLayout;

import com.yilos.secretary.common.LoggerManager;
import com.yilos.secretary.R;
import com.yilos.secretary.bean.MyShopBean;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.common.LoggerFactory;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.database.SDBHelper;
import com.yilos.secretary.service.MemberService;
import com.yilos.secretary.service.MyshopManageService;

public class LaunchActivity extends BaseActivity {
	private static final Logger LOGGER = LoggerFactory
			.getLogger(LaunchActivity.class);
	private MyshopManageService myshopService;
	private LinearLayout loading_begin;

	private String shopName;

	private String userAccount;

	private String shopId;
	private String last_sync = "0";
	private List<MyShopBean> myshops;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.launch);
		loading_begin = (LinearLayout) findViewById(R.id.loading_begin);
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		
		if("LoginActivity".equals(getIntent().getStringExtra("forwardClass")))
		{
			loading_begin.setVisibility(View.VISIBLE);
		}
		else
		{
			 Intent intent = new Intent(LaunchActivity.this, MainTabActivity.class);
	         startActivity(intent);
		}
	}
	
	public void onResume() {
		super.onResume();
		
		if("LoginActivity".equals(getIntent().getStringExtra("forwardClass")))
		{
			initdata(); 
		}
	}

	final Handler handle = new Handler() {
		
		public void handleMessage(Message msg) {

			if (msg.what == 1) {
				loading_begin.setVisibility(View.GONE);
				if(!AppContext.getInstance(getBaseContext()).isLogin())
				{
					UIHelper.ToastMessage(getBaseContext(), "登录成功");
				}
				AppContext.getInstance(getBaseContext()).setLogin(true);
				AppContext.getInstance(getBaseContext()).setChangeShop(true);
				// WIFI环境下，上传日志文件
				if (NetworkUtil.WIFI == NetworkUtil.getNetworkState(getBaseContext())) {
					LoggerManager.uploadLoggerFile(getApplicationContext(), 0);
				}
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
		myshopService = new MyshopManageService(getBaseContext());
			if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
			{
			   getLinkShop();
			}
			else
			{
				UIHelper.ToastMessage(getBaseContext(), "网络链接不可用，初始化失败");
			    Intent intent = new Intent(LaunchActivity.this, LoginActivity.class);
	            startActivity(intent);
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
					
					myshops = myshopService.getAllLinkshop();

						for(int i =0;i<res.getResult().getMyShopList().size();i++)
						{
							boolean updateFlag = false;
							for(int j =0;j<myshops.size();j++)
							{
								if(myshops.get(j).getEnterprise_id().equals(res.getResult().getMyShopList().get(i).getEnterprise_id()))
								{
									updateFlag = true;
									myshopService.updateShops(res.getResult().getMyShopList().get(i));
									break;
								}
							}
							if(!updateFlag)
							{
								myshopService.addShop(res.getResult().getMyShopList().get(i));
							}
						}
						myshops = myshopService.queryShops();
						if (myshops != null && myshops.size() > 0)
						{
							shopId = myshops.get(0).getEnterprise_id();
							AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(
									shopId);
							last_sync = myshops.get(0).getContactSyncTime();
							AppContext.getInstance(getBaseContext()).setContactLastSyncTime(last_sync);
							if(myshops.get(0).getEnterprise_name()==null ||"".equals(myshops.get(0).getEnterprise_name()))
							{
								shopName = "我的店铺";
							}
							else
							{
								shopName = myshops.get(0).getEnterprise_name();
							}

							AppContext.getInstance(getBaseContext()).setShopName(shopName);
						}
						else
						{
							shopName ="我的店铺";
							AppContext.getInstance(getBaseContext()).setShopName(shopName);
						}

					msg.what = 1;
				}
				if (res.getCode() == 1) {
					msg.what = 0;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

}
