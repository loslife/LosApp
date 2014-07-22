package com.yilos.losapp;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.yilos.losapp.adapter.ListViewAdp;
import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.NetworkUtil;
import com.yilos.losapp.common.Pinyin_Comparator;
import com.yilos.losapp.common.SideBar;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;
import com.yilos.losapp.view.RefreshableView;
import com.yilos.losapp.view.RefreshableView.PullToRefreshListener;

public class MemberGoupActivity extends BaseActivity {
	private static List<MemberBean> parentData = new ArrayList<MemberBean>();

	private ListView lvContact;
	private SideBar indexBar;
	private WindowManager mWindowManager;
	private TextView mDialogText;
	private EditText seachmemberext;
	private LinearLayout layout_loadingmember;
	private LinearLayout layout_memberlist;
	private RefreshableView refreshableView;
	private TextView loadingmember;
	private LinearLayout loading_begin;
	private RelativeLayout layout_loadingfail;
	private TextView loadcountinfo;
	private TextView reloading;

	String[] members;
	String[] memberNames;
	String[] memberIds;
	String memberName;
	static int i;
	ListViewAdp lAdp;

	private PopupWindow popupWindow;
	private LinearLayout layout;
	private ListView listView;
	private String title[] = null;
	private String shopIds[] = null;

	private MemberService memberService;

	private MyshopManageService myshopService;

	private String shopId;
	
	private String shoptitle;

	private String last_sync = "0";
	
	private String count;

	private TextView shopname;
	private ImageView select_shop;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.mebersgroup);
		lvContact = (ListView) this.findViewById(R.id.lvContact);
		mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
		memberService = new MemberService(getBaseContext());
		shoptitle = AppContext.getInstance(getBaseContext()).getShopName();
	}

	public void onResume() {
		super.onResume();
		getdata();
	}
	
	public void onPause()
	  {
		  super.onPause();
		  shopId = AppContext.getInstance(getBaseContext())
					.getCurrentDisplayShopId();
	  }
	
	final Handler handle = new Handler() {
			
			public void handleMessage(Message msg) {
				if(msg.what==1)
				{
					String memberLoadInfo = "本店共有"+count+"位会员，正在努力为你加载中...";
					loadcountinfo.setText(memberLoadInfo);
					if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
					{
					   getMemberContact(shopId,"0");
					}
					else
					{
						//加载失败检查网络
						layout_loadingfail.setVisibility(View.VISIBLE);
						loading_begin.setVisibility(View.GONE);
					}
				}
				
				if(msg.what==2)
				{
					loading_begin.setVisibility(View.GONE);
					getdata();
				}
			}
	};

	public void initView() {
		
		findView();
		
		if (null != parentData && parentData.size() > 0) 
		{
			
		    layout_loadingmember.setVisibility(View.GONE);
			layout_memberlist.setVisibility(View.VISIBLE);
			members = null;
			members = new String[parentData.size()];

			for (int i = 0; i < parentData.size(); i++) {
				members[i] = parentData.get(i).getName() + "|" + i;
			}
			Arrays.sort(members, new Pinyin_Comparator());

			lAdp = new ListViewAdp(MemberGoupActivity.this, members,parentData);
			lvContact.setAdapter(lAdp);
			lvContact.setOnItemClickListener(new OnItemClickListener() {
				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int arg2, long arg3) {
					memberName = members[arg2];
					int index = memberName.indexOf("|");
					String p = memberName.substring(index + 1,
							memberName.length());

					Intent memberDetail = new Intent();
					memberDetail.putExtra("memberInfo",
							parentData.get(Integer.parseInt(p)));
					memberDetail.setClass(getBaseContext(),
							MemberDetailActivity.class);
					startActivity(memberDetail);
				}
			});
		} else {
			if(!(seachmemberext.getText().length()>0))
			{
			   layout_loadingmember.setVisibility(View.VISIBLE);
			   layout_memberlist.setVisibility(View.GONE);
			}
		}
		seachmemberext.setOnFocusChangeListener(new View.OnFocusChangeListener() {  
		      
		    @Override  
		    public void onFocusChange(View v, boolean hasFocus) {  
		        if(hasFocus){  
		        	seachmemberext.setCompoundDrawables(getResources().getDrawable(R.drawable.search), null, null, null);
		        } 
		    }             
		});  
		seachmemberext.addTextChangedListener(new TextWatcher() {

			@Override
			public void afterTextChanged(Editable s) {

			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {

			}
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				parentData = memberService.seachRecords(shopId, s.toString());
				initView();
			}

		});

		select_shop = (ImageView) findViewById(R.id.headmore);
		if (title == null || !(title.length > 0)) {
			select_shop.setVisibility(View.GONE);
		}
		select_shop.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				select_shop.getRight();
				int y = select_shop.getBottom() * 2;
				int x = getWindowManager().getDefaultDisplay().getWidth() / 2;

				showPopupWindow(x, y);
			}
		});

	}

	private void findView() {

		indexBar = (SideBar) findViewById(R.id.sideBar);
		indexBar.setListView(lvContact);
		mDialogText = (TextView) LayoutInflater.from(this).inflate(
				R.layout.list_position, null);
		mDialogText.setVisibility(View.INVISIBLE);

		layout_loadingmember = (LinearLayout) findViewById(R.id.layout_loadingmember);
		layout_memberlist =  (LinearLayout) findViewById(R.id.layout_memberlist);
		loadingmember = (TextView) findViewById(R.id.loadingmember);
		reloading = (TextView) findViewById(R.id.reloading);
		refreshableView = (RefreshableView) findViewById(R.id.refreshable_view);
		seachmemberext = (EditText) findViewById(R.id.seachmemberext);
		loading_begin = (LinearLayout) findViewById(R.id.loading_begin);
		loadcountinfo = (TextView) findViewById(R.id.loadcountinfo);
		layout_loadingfail = (RelativeLayout) findViewById(R.id.layout_loadingfail);

		shopname = (TextView) findViewById(R.id.shopname);
		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		findViewById(R.id.goback).setVisibility(View.GONE);
		
		refreshableView.setOnRefreshListener(new PullToRefreshListener() {
			@Override
			public void onRefresh() {
				try {
					Thread.sleep(3000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				refreshableView.finishRefreshing();
			}
		}, 0);
       loadingmember.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				loading_begin.setVisibility(View.VISIBLE);
				layout_loadingmember.setVisibility(View.GONE);
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					getMemberCounts(shopId);
				}
				else
				{
					//加载失败检查网络
					layout_loadingfail.setVisibility(View.VISIBLE);
					loading_begin.setVisibility(View.GONE);
				}
			}
		});
       reloading.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					loading_begin.setVisibility(View.VISIBLE);
					layout_loadingfail.setVisibility(View.GONE);
					layout_loadingmember.setVisibility(View.GONE);
					getMemberCounts(shopId);
				}
				else
				{
					//加载失败检查网络
					UIHelper.ToastMessage(v.getContext(), "当前网络不佳，请检查网络");
				}
			}
		});
		WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT,
				WindowManager.LayoutParams.TYPE_APPLICATION,
				WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
						| WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
				PixelFormat.TRANSLUCENT);
		mWindowManager.addView(mDialogText, lp);
		indexBar.setTextView(mDialogText);
	}
	

	public void getdata() 
	{
		last_sync = AppContext.getInstance(getBaseContext())
				.getContactLastSyncTime();
		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		memberService = new MemberService(getBaseContext());
		myshopService = new MyshopManageService(getBaseContext());
		if (null != shopId && !"".equals(shopId)) {
			parentData = memberService.queryMembers(shopId);
		}

		myshopService = new MyshopManageService(getBaseContext());
		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			title = new String[myshops.size()];
			shopIds = new String[myshops.size()];
			for (int i = 0; i < myshops.size(); i++) {
				title[i] = myshops.get(i).getEnterprise_name();
				shopIds[i] = myshops.get(i).getEnterprise_id();
			}
		}
		initView();
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
						msg.what = 2;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}
	
	/**
	 * 获取会员数量
	 * @param linkshopId
	 */
	public void getMemberCounts(final String linkshopId)
	{
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();

				ServerMemberResponse res = ac.getMembersCount(linkshopId);
				if (res.isSucess()) {
					
						count = res.getResult().getCount();
						msg.what = 1;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

	public void showPopupWindow(int x, int y) {
		layout = (LinearLayout) LayoutInflater.from(getBaseContext()).inflate(
				R.layout.dialog, null);
		listView = (ListView) layout.findViewById(R.id.lv_dialog);
		listView.setAdapter(new ArrayAdapter<String>(getBaseContext(),
				R.layout.text, R.id.tv_text, title));

		popupWindow = new PopupWindow(getBaseContext());
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow
				.setWidth(getWindowManager().getDefaultDisplay().getWidth() / 2);
		popupWindow.setHeight(300);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		// showAsDropDown会把里面的view作为参照物，所以要那满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.LEFT
				| Gravity.TOP, x, y);// 需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				shoptitle = title[arg2];
				AppContext.getInstance(getBaseContext()).setShopName(title[arg2]);
				AppContext.getInstance(getBaseContext())
						.setCurrentDisplayShopId(shopIds[arg2]);
				shopId = shopIds[arg2];
				parentData = memberService.queryMembers(shopIds[arg2]);
				initView();
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

}
