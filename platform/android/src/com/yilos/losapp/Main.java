package com.yilos.losapp;

import java.util.List;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

public class Main extends Activity {

	private TextView operate;

	private TextView contacts;

	private TextView setting;
	
	private String shopId;

	private MyshopManageService myshopService;
	
	private String userAccount;
	
	private String last_sync = "0";
	
	private ImageView select_shop;
	
	private TextView  shopname;
	
	private Button button;
	private PopupWindow popupWindow;
	private LinearLayout layout;
	private ListView listView;
	private String title[] = null;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initData();
		initView();
	}
	
	public void initView()
	{
		select_shop = (ImageView)findViewById(R.id.headmore);
		shopname = (TextView)findViewById(R.id.shopname);
		shopname.setText(getIntent().getStringExtra("shopName"));
		select_shop.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				select_shop.getRight();
				int y = select_shop.getBottom()*2;
				int x = getWindowManager().getDefaultDisplay().getWidth() / 2;

				showPopupWindow(x, y);
			}
		});
		//initFootBar();
	}

	/**
	 * 初始化底部栏
	 */
	private void initFootBar() {

		operate = (TextView) findViewById(R.id.operate);

		contacts = (TextView) findViewById(R.id.contacts);

		setting = (TextView) findViewById(R.id.setting);

		contacts.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), MemberGoupActivity.class);
				startActivity(contacts);
			}
		});

		setting.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), SettingActivity.class);
				startActivity(contacts);
			}
		});

	}

	public void initData() {

		myshopService = new MyshopManageService(getBaseContext());
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) 
		{
			shopId = myshops.get(0).getEnterprise_id();
			AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
			title = new String[myshops.size()];
			for(int i=0;i<myshops.size();i++)
			{
				title[i]=myshops.get(i).getEnterprise_name();
			}
			
		}else
		{
			//getLinkShop();
		}
		
		
	}
	
	public void getLinkShop()
	{
	
		final Handler handle =new Handler(){
			 public void handleMessage(Message msg)
			{
				 if(msg.what==1)
					{
					 List<MyShopBean> myshops = myshopService.queryShops();
					 if(myshops!=null&&myshops.size()>0)
					 {
						 shopId = myshops.get(0).getEnterprise_id();
						 last_sync = myshops.get(0).getLatest_sync();
					     AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
					     //AppContext.getInstance(getBaseContext()).setLastSyncTime(last_sync);
					 }
					 else
					 {
						 UIHelper.ToastMessage(getBaseContext(), "没有关联店铺");
					 }
					 
				     title = new String[myshops.size()];
						for(int i=0;i<myshops.size();i++)
						{
							title[i]=myshops.get(i).getEnterprise_name();
						}
					}
					if(msg.what==0)
					{
						
					}
			}
			
		};
	   new Thread(){
		   public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.getMyshopList(userAccount);
				if(res.isSucess())
				{
					myshopService.addShops(res.getResult().getMyShopList());
					msg.what = 1;
				}
				if(res.getCode()==1)
				{
					msg.what = 0;
				}
				handle.sendMessage(msg);
			}
	   }.start();
	}

	
	public void showPopupWindow(int x, int y) {
		layout = (LinearLayout) LayoutInflater.from(Main.this).inflate(
				R.layout.dialog, null);
		listView = (ListView) layout.findViewById(R.id.lv_dialog);
		listView.setAdapter(new ArrayAdapter<String>(Main.this,
				R.layout.text, R.id.tv_text, title));

		popupWindow = new PopupWindow(Main.this);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow
				.setWidth(getWindowManager().getDefaultDisplay().getWidth() / 2);
		popupWindow.setHeight(300);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		// showAsDropDown会把里面的view作为参照物，所以要那满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.LEFT
				| Gravity.TOP, x, y);//需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				shopname.setText(title[arg2]);
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

}
