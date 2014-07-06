package com.yilos.losapp;


import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class SettingActivity extends BaseActivity{

	private TextView headtitle;
	
	private ImageView  headmore;
	
	private RelativeLayout linkShop;

	private RelativeLayout modfiypwd; 
	
	private RelativeLayout aboutlos; 
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting);
		
		initView();
		
	}
	
	private void initView()
	{
		headtitle = (TextView)findViewById(R.id.shopname);
		headtitle.setText("设置");
		
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		
		findViewById(R.id.goback).setVisibility(View.GONE);
		
		linkShop = (RelativeLayout)findViewById(R.id.relativelayout_linkshop);
		modfiypwd = (RelativeLayout)findViewById(R.id.relativelayout_modfiypwd);
		aboutlos = (RelativeLayout)findViewById(R.id.relativelayout_aboutlos);
		findViewById(R.id.goback).setVisibility(View.GONE);
		
		linkShop.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent linkshop = new Intent();
				linkshop.setClass(getBaseContext(), LinkShopActivity.class);
				startActivity(linkshop);
			}
		});
		
		modfiypwd.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent modifypwd = new Intent();
				modifypwd.setClass(getBaseContext(), ModifyPwdActivity.class);
			startActivity(modifypwd);
				
			}
		});
		
		aboutlos.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
			}
		});
	}
}
