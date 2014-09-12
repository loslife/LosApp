package com.yilos.secretary;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.LinearLayout.LayoutParams;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.adapter.ListViewAdp;
import com.yilos.secretary.bean.MemberBean;
import com.yilos.secretary.bean.MyShopBean;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.Pinyin_Comparator;
import com.yilos.secretary.common.SideBar;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.service.MemberService;
import com.yilos.secretary.service.MyshopManageService;
import com.yilos.secretary.view.RefreshableView;
import com.yilos.secretary.view.RefreshableView.PullToRefreshListener;

public class MemberGoupActivity extends BaseActivity {
	private static List<MemberBean> parentData = new ArrayList<MemberBean>();

	private ListView lvContact;
	private SideBar indexBar;
	private WindowManager mWindowManager;
	private TextView mDialogText;
	private RelativeLayout seach_layout;
	private LinearLayout member_seach;
	private EditText seachmemberext;
	private TextView membercount;
	private LinearLayout layout_loadingmember;
	private LinearLayout layout_memberlist;
	private RefreshableView refreshableView;
	private SwipeRefreshLayout swipeRefreshLayout; 
	private TextView loadingmember;
	private LinearLayout loading_begin;
	private RelativeLayout layout_loadingfail;
	private TextView loadcountinfo;
	private TextView reloading;
	private TextView cancelsearch;
	private LinearLayout pullrefresh;
	private LinearLayout noshop;

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
	private String titleList[] = null;
	private String shopIds[] = null;

	private MemberService memberService;

	private MyshopManageService myshopService;

	private String shopId;
	
	private String shoptitle;

	private String last_sync = "0";
	
	private String count;

	private TextView shopname;
	private LinearLayout select_shop;
	
	private String shopListViewId = "0";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.mebersgroup);
		memberService = new MemberService(getBaseContext());
	}

	public void onResume() {
		super.onResume();
		
		shoptitle = AppContext.getInstance(getBaseContext()).getShopName();
		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		getdata();
	}

	
	final Handler handle = new Handler() {
			
			public void handleMessage(Message msg) {
				if(msg.what==1)
				{
					String memberLoadInfo = "本店共有"+count+"位会员，正在努力为您加载中...";
					loadcountinfo.setText(memberLoadInfo);
					
					if("0".equals(count))
					{
						UIHelper.ToastMessage(getBaseContext(), "该店铺还未有会员");
						loading_begin.setVisibility(View.GONE);
						layout_loadingmember.setVisibility(View.VISIBLE);
					}
					else
					{
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
				}
				
				if(msg.what==2)
				{
					loading_begin.setVisibility(View.GONE);
					getdata();
					seachmemberext.setText("");
					refreshableView.finishRefreshing();
				}
				
				if(msg.what==3)
				{
					UIHelper.ToastMessage(getBaseContext(), "网络不给力");
					seachmemberext.setText("");
					refreshableView.finishRefreshing();
				}
			}
	};

	public void initView() {

		if (null != parentData && parentData.size() > 0) 
		{
			shopListViewId = parentData.get(0).getEnterprise_id();
			noshop.setVisibility(View.GONE);
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
			if(null != shopId && !"".equals(shopId)&&!(seachmemberext.getText().length()>0))
			{
			   layout_loadingmember.setVisibility(View.VISIBLE);
			   layout_memberlist.setVisibility(View.GONE);
			}
		}
		
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
				filterData(s.toString());
			}

		});

		select_shop.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				((ImageView)findViewById(R.id.headmore)).getRight();
				int y = ((ImageView)findViewById(R.id.headmore)).getBottom() * 2;
				int x = getWindowManager().getDefaultDisplay().getWidth() / 2;
				LinearLayout imageView = (LinearLayout) v;
				Integer integer = (Integer) imageView.getTag();
				integer = integer == null ? 0 : integer;
				if(integer==R.drawable.select_shop)
				{
					((ImageView)findViewById(R.id.headmore)).setImageDrawable(getBaseContext().getResources().getDrawable(R.drawable.retract));
					select_shop.setTag(R.drawable.retract);
				}
				else
				{
					((ImageView)findViewById(R.id.headmore)).setImageDrawable(getBaseContext().getResources().getDrawable(R.drawable.select_shop));
					select_shop.setTag(R.drawable.select_shop);
				}
				showPopupWindow(x, y);
			}
		});

	}
	

	/**
	 * 根据输入框中的值来过滤数据并更新ListView
	 * @param filterStr
	 */
	private void filterData(String filterStr)
	{
		List<String> filterList = new ArrayList<String>();
		for(int i= 0;i<members.length;i++)
		{   
			int p = members[i].indexOf("|");
			if(members[i].substring(0, p).toUpperCase().contains(filterStr.toUpperCase()))
			{
				filterList.add(members[i]);
			}
		}
		String[] nameArr = new String[filterList.size()];    
		filterList.toArray(nameArr);    
		lAdp = new ListViewAdp(MemberGoupActivity.this, nameArr,parentData);
		lvContact.setAdapter(lAdp);
	}

	private void findView() {

		layout_loadingmember = (LinearLayout) findViewById(R.id.layout_loadingmember);
		layout_memberlist =  (LinearLayout) findViewById(R.id.layout_memberlist);
		loadingmember = (TextView) findViewById(R.id.loadingmember);
		reloading = (TextView) findViewById(R.id.reloading);
		refreshableView = (RefreshableView) findViewById(R.id.refreshable_view);
		seachmemberext = (EditText) findViewById(R.id.seachmemberext);
		loading_begin = (LinearLayout) findViewById(R.id.loading_begin);
		loadcountinfo = (TextView) findViewById(R.id.loadcountinfo);
		layout_loadingfail = (RelativeLayout) findViewById(R.id.layout_loadingfail);
		seach_layout  = (RelativeLayout) findViewById(R.id.seach_layout);
		member_seach =  (LinearLayout) findViewById(R.id.member_seach);
		membercount = (TextView) findViewById(R.id.membercount);
		cancelsearch = (TextView) findViewById(R.id.cancelsearch);
		 pullrefresh =  (LinearLayout) findViewById(R.id.pullrefresh);
		shopname = (TextView) findViewById(R.id.shopname);
		noshop = (LinearLayout) findViewById(R.id.noshop);
		select_shop = (LinearLayout) findViewById(R.id.select_shop_layout);
		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		findViewById(R.id.goback).setVisibility(View.GONE);
		
		pullrefresh.setVisibility(View.GONE);
		
		initIndexBar();
		refreshableView.setOnRefreshListener(new PullToRefreshListener() {
			@Override
			public void onRefresh() {
				    
					if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
					{
					   getMemberContact(shopId,last_sync); 
					}
					else
					{
						getMemberContact(shopId,last_sync);
						Message msg = new Message();
						msg.what=3;
						handle.sendMessage(msg);
					}
					
			}
		}, 0);
		
		
       loadingmember.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				loading_begin.setVisibility(View.VISIBLE);
				layout_loadingmember.setVisibility(View.GONE);
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					if(NetworkUtil.checkNetworkIsOk(getBaseContext())==NetworkUtil.WIFI)
					{
    	                 getMemberCounts(shopId);
					}
					else
					{
						 //警告框  
                        new AlertDialog.Builder(MemberGoupActivity.this)  
                        .setMessage("您当前使用的是非wifi网络，加载速度比较慢，建议您在wifi环境下加载会员。是否继续？")  
                        .setPositiveButton("是", new DialogInterface.OnClickListener() {  
                            public void onClick(DialogInterface dialog, int which) {
                            	  getMemberCounts(shopId);
                            }  
                        })  
                        .setNegativeButton("否", new DialogInterface.OnClickListener() {    
                            public void onClick(DialogInterface dialog, int whichButton) {  
                            	loading_begin.setVisibility(View.GONE);
                				layout_loadingmember.setVisibility(View.VISIBLE);
                            }    
                        })  
                        .create()  
                        .show();  
					}
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
					UIHelper.ToastMessage(v.getContext(), "网络连接不可用，请检查网络设置");
				}
			}
		});
       
       //会员搜索
       seach_layout.setOnClickListener(new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			member_seach.setVisibility(View.VISIBLE);
			seach_layout.setVisibility(View.GONE);
			seachmemberext.requestFocus();
			((InputMethodManager)getSystemService(INPUT_METHOD_SERVICE)).toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS);
			seachmemberext.setHint("共有"+parentData.size()+"名会员");
		}
	   });
       
       cancelsearch.setOnClickListener(new OnClickListener() {
   		@Override
   		public void onClick(View v) {
   			seachmemberext.setText("");
   			member_seach.setVisibility(View.GONE);
   			seach_layout.setVisibility(View.VISIBLE);
   			parentData = memberService.queryMembers(shopId);
   			initView();
   		}
   	   });

	}
	
	public void initIndexBar()
	{
		lvContact = (ListView) this.findViewById(R.id.lvContact);
		mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
		
		indexBar = (SideBar) findViewById(R.id.sideBar);
		indexBar.setListView(lvContact);
		mDialogText = (TextView) LayoutInflater.from(this).inflate(
				R.layout.list_position, null);
		mDialogText.setVisibility(View.INVISIBLE);

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
		findView();
		
		last_sync = AppContext.getInstance(getBaseContext())
				.getContactLastSyncTime();
	    
		memberService = new MemberService(getBaseContext());
		myshopService = new MyshopManageService(getBaseContext());
		
		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			title = new String[myshops.size()];
			titleList = new String[myshops.size()];
			shopIds = new String[myshops.size()];
			for (int i = 0; i < myshops.size(); i++) {
				title[i] = myshops.get(i).getEnterprise_name()==null?"我的店铺":myshops.get(i).getEnterprise_name();
				titleList[i] = myshops.get(i).getEnterprise_name() == null ? "• 我的店铺"
						: "• " + myshops.get(i).getEnterprise_name();
				shopIds[i] = myshops.get(i).getEnterprise_id();
			}

			shopname.setText(shoptitle==null?"我的店铺":shoptitle);
			select_shop.setVisibility(View.VISIBLE);
		    parentData = memberService.queryMembers(shopId);
		    if("0".equals(shopListViewId)||!shopListViewId.equals(shopId))
		    {
		    	initView();
		    }
			
			membercount.setText("共有"+parentData.size()+"名会员");
		}
		else
		{
			shopListViewId = "0";
			loading_begin.setVisibility(View.GONE);
			select_shop.setVisibility(View.GONE);
			noshop.setVisibility(View.VISIBLE);
			shopname.setText("我的店铺");
			layout_loadingmember.setVisibility(View.GONE);
			parentData = null;
			shopId ="";
		}
   
		
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
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
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
				}
				else
				{
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
				R.layout.text, R.id.tv_text, titleList ){
					// 在这个重写的函数里设置 每个 item 中按钮的响应事件
					@Override
					public View getView(int position, View convertView, ViewGroup parent) {
						final View view=super.getView(position, convertView, parent);  
						if(shopIds[position] .equals(shopId) )
						{
							((TextView)view.findViewById(R.id.tv_text)).setTextColor(getBaseContext().getResources().getColor(R.color.paneldount_one));
						}
						else
						{
							((TextView)view.findViewById(R.id.tv_text)).setTextColor(getBaseContext().getResources().getColor(R.color.blue_text));
						}
						
						return view;
					}
				});

		popupWindow = new PopupWindow(getBaseContext());
		popupWindow.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {
				((ImageView)findViewById(R.id.headmore)).setImageDrawable(getBaseContext().getResources().getDrawable(R.drawable.select_shop));
				select_shop.setTag(R.drawable.select_shop);
			}
		});
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow
				.setWidth(getWindowManager().getDefaultDisplay().getWidth()*2 / 5);
		if(title.length <5)
		{
			popupWindow.setHeight(title.length * (getWindowManager().getDefaultDisplay().getWidth() / 10)+10);
		}
		else
		{
			popupWindow.setHeight(5 * (getWindowManager().getDefaultDisplay().getWidth() / 10)+10);
		}
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		// showAsDropDown会把里面的view作为参照物，所以要那满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.CENTER
				| Gravity.TOP, x, y);// 需要指定Gravity，默认情况是center.
		((ImageView)findViewById(R.id.headmore)).setImageResource(R.drawable.retract);
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				if (shopId.equals(shopIds[arg2])) {
					popupWindow.dismiss();
					popupWindow = null;
					((ImageView)findViewById(R.id.headmore)).setImageResource(R.drawable.select_shop);
					return;
				}
				shoptitle = title[arg2];
				shopname.setText(shoptitle);
				AppContext.getInstance(getBaseContext()).setShopName(shoptitle);
				AppContext.getInstance(getBaseContext())
						.setCurrentDisplayShopId(shopIds[arg2]);
				AppContext.getInstance(getBaseContext()).setChangeShop(true);
				shopId = shopIds[arg2];
				parentData = memberService.queryMembers(shopIds[arg2]);
				membercount.setText("共有"+parentData.size()+"名会员");
				initView();
				popupWindow.dismiss();
				popupWindow = null;
				((ImageView)findViewById(R.id.headmore)).setImageResource(R.drawable.select_shop);
			}
		});
	}
	
	@Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {  
        if (keyCode == KeyEvent.KEYCODE_BACK) {  
        	  Intent i = new Intent(Intent.ACTION_MAIN);
        	  i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        	  i.addCategory(Intent.CATEGORY_HOME);
        	  startActivity(i);
             
            return false;  
        } else {  
            return super.onKeyDown(keyCode, event);  
        }  
    }  

}
