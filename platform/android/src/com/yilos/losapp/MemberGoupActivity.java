package com.yilos.losapp;

import java.util.ArrayList;
import java.util.Arrays;

import com.yilos.losapp.R.color;
import com.yilos.losapp.adapter.ListViewAdp;
import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.common.Pinyin_Comparator;
import com.yilos.losapp.common.SideBar;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout.LayoutParams;


public class MemberGoupActivity extends Activity{
	private static ArrayList<MemberBean> parentData = new ArrayList<MemberBean>();

	private ListView lvContact;
	private SideBar indexBar;
	private WindowManager mWindowManager;
	private TextView mDialogText;
	String[] members;
	String memberName;
	static int i;
	ListViewAdp lAdp;
	
    private TextView operate;
	
	private TextView contacts;
	
	private TextView setting;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.mebersgroup);
		lvContact = (ListView) this.findViewById(R.id.lvContact);
		mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);

		initFootBar();
		
		getdata();

		initView();
	}

	public void initView() {
		members = null;

		members = new String[parentData.size()];
		for (int i = 0; i < parentData.size(); i++) {
			members[i] = parentData.get(i).getMemberName();

		}
		Arrays.sort(members, new Pinyin_Comparator());
		lAdp = new ListViewAdp(MemberGoupActivity.this, members);
		lvContact.setAdapter(lAdp);
		lvContact.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				memberName = members[arg2];
				Toast.makeText(MemberGoupActivity.this, memberName,
						Toast.LENGTH_SHORT).show();
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

		WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT,
				WindowManager.LayoutParams.TYPE_APPLICATION,
				WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
						| WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
				PixelFormat.TRANSLUCENT);
		mWindowManager.addView(mDialogText, lp);
		indexBar.setTextView(mDialogText);
	}
	
	/**
	 * 初始化底部栏
	 */
	private void initFootBar() {

		operate = (TextView)findViewById(R.id.operate);
		operate.setBackgroundColor(color.turquoise);
		
		contacts = (TextView)findViewById(R.id.contacts);
		contacts.setBackgroundColor(color.orange);
		
		
		setting = (TextView)findViewById(R.id.setting);
		
		operate.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), Main.class);
				startActivity(contacts);
			}
		});

	}

	public void getdata() {
		MemberBean m1 = new MemberBean();
		m1.setMemberName("王MM");

		MemberBean m2 = new MemberBean();
		m2.setMemberName("李MM");
		MemberBean m3 = new MemberBean();
		m3.setMemberName("张MM");
		MemberBean m4 = new MemberBean();
		m4.setMemberName("艾MM");
		MemberBean m5 = new MemberBean();
		m5.setMemberName("江MM");
		MemberBean m6 = new MemberBean();
		m6.setMemberName("郑MM");
		MemberBean m7 = new MemberBean();
		m7.setMemberName("曹MM");
		MemberBean m8 = new MemberBean();
		m8.setMemberName("王MM");
		MemberBean m9 = new MemberBean();
		m9.setMemberName("白MM");

		MemberBean m10 = new MemberBean();
		m10.setMemberName("赵MM");
		MemberBean m11 = new MemberBean();
		m11.setMemberName("王MM");
		MemberBean m12 = new MemberBean();
		m12.setMemberName("黄MM");
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
		parentData.add(m12);

	}
}
