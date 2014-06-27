package com.yilos.losapp;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.yilos.losapp.R.color;
import com.yilos.losapp.adapter.ListViewAdp;
import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.Pinyin_Comparator;
import com.yilos.losapp.common.SideBar;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.database.MemberDBManager;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Layout;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout.LayoutParams;


public class MemberGoupActivity extends Activity{
	private static List<MemberBean> parentData = new ArrayList<MemberBean>();

	private ListView lvContact;
	private SideBar indexBar;
	private WindowManager mWindowManager;
	private TextView mDialogText;
	
	private ImageView seachmember;
	private  RelativeLayout member_title;
	private  RelativeLayout member_seach;
	
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
	
	private String last_sync = "0";
	
	private TextView  shopname;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.mebersgroup);
		lvContact = (ListView) this.findViewById(R.id.lvContact);
		mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);

		getdata();
	}
	
	@Override
	public void onResume()
	{
		super.onResume();
		getdata();
	}

	public void initView() {
		
		members = null;
	
		members = new String[parentData.size()];

		for (int i = 0; i < parentData.size(); i++) {
			members[i] = parentData.get(i).getName()+"|"+i;
		}
		Arrays.sort(members, new Pinyin_Comparator());

		lAdp = new ListViewAdp(MemberGoupActivity.this, members);
		lvContact.setAdapter(lAdp);
		lvContact.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				memberName = members[arg2];
				int index = memberName.indexOf("|");
				String p = memberName.substring(index+1, memberName.length());
				
				Toast.makeText(MemberGoupActivity.this, memberName,
						Toast.LENGTH_SHORT).show();
				Intent memberDetail = new Intent();
				memberDetail.putExtra("memberInfo", parentData.get(Integer.parseInt(p)));
				memberDetail.setClass(getBaseContext(), MemberDetailActivity.class);
				startActivity(memberDetail);
			}
		});
		findView();
	}

	private void findView() {

		indexBar = (SideBar) findViewById(R.id.sideBar);
		indexBar.setListView(lvContact);
		mDialogText = (TextView) LayoutInflater.from(this).inflate(
				R.layout.list_position, null);
		mDialogText.setVisibility(View.INVISIBLE);
		
		shopname = (TextView)findViewById(R.id.shopname);
		member_title = (RelativeLayout)findViewById(R.id.member_title);
		member_seach = (RelativeLayout)findViewById(R.id.member_seach);
		seachmember = (ImageView)findViewById(R.id.seachmember);
		seachmember.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				member_title.setVisibility(View.GONE);
				member_seach.setVisibility(View.VISIBLE);
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
	
	
	public void getdata() {
		
		
	/*	MemberBean m1 = new MemberBean();
		m1.setName("王MM");

		MemberBean m2 = new MemberBean();
		m2.setName("李MM");
		MemberBean m3 = new MemberBean();
		m3.setName("张MM");
		MemberBean m4 = new MemberBean();
		m4.setName("艾MM");
		MemberBean m5 = new MemberBean();
		m5.setName("江MM");
		MemberBean m6 = new MemberBean();
		m6.setName("郑MM");
		MemberBean m7 = new MemberBean();
		m7.setName("曹MM");
		MemberBean m8 = new MemberBean();
		m8.setName("王MM");
		MemberBean m9 = new MemberBean();
		m9.setName("白MM");

		MemberBean m10 = new MemberBean();
		m10.setName("赵MM");
		MemberBean m11 = new MemberBean();
		m11.setName("王MM");
		MemberBean m12 = new MemberBean();
		m12.setName("黄MM");
		parentData.add(m1);
		parentData.add(m2);
		parentData.add(m3);
		parentData.add(m4);
		parentData.add(m5);
		parentData.add(m6);
		parentData.add(m7);
		parentData.add(m8);
		parentData.add(m9);
		parentData.add(m10);
		parentData.add(m11);
		parentData.add(m12);*/
		
		last_sync = AppContext.getInstance(getBaseContext()).getContactLastSyncTime();
		shopId = AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId();
		memberService = new MemberService(getBaseContext());
		myshopService = new MyshopManageService(getBaseContext());
		parentData = memberService.queryMembers(shopId);
		initView();
		
		//downMembersContacts();
		
		myshopService = new MyshopManageService(getBaseContext());
		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) 
		{
			title = new String[myshops.size()];
			shopIds = new String[myshops.size()];
			for(int i=0;i<myshops.size();i++)
			{
				title[i] = myshops.get(i).getEnterprise_name();
				shopIds[i] = myshops.get(i).getEnterprise_id();
			}
		}
	}
	
	public void downMembersContacts()
	{
		
		final Handler handle =new Handler(){
			 public void handleMessage(Message msg)
			{
				 if(msg.what==1)
					{
					    parentData = memberService.queryMembers(shopId);
					    initView();
					}
					if(msg.what==0)
					{
						UIHelper.ToastMessage(getBaseContext(), "获取通讯录失败");
					}
			}
			
		};
	   new Thread(){
		   public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.getMembersContacts(shopId,last_sync);
				if(res.isSucess())
				{
					memberService.handleMembers(res.getResult().getRecords());
					last_sync = String.valueOf(res.getResult().getLast_sync());
					myshopService.updateLatestSync(last_sync, shopId, "Contacts");
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
				| Gravity.TOP, x, y);//需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				shopname.setText(title[arg2]);
				AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopIds[i]);
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

	
}
