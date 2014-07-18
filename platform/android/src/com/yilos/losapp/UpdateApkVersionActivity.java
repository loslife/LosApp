package com.yilos.losapp;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.sax.TextElementListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class UpdateApkVersionActivity extends Activity
{
	private TextView headtitle;
	
	private TextView versionText;
	
	private TextView directionsText;
	
	private TextView updateapk;
	
	private ImageView headmore;
	
	private String vsersionInfo;
	
	private ArrayList<String> dirvectionsList;
	
	private String dirvectionsInfo="";
	
	public void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.updateapkversion);
		
		initView();
		
	}
	
	private void initView()
	{
		updateapk = (TextView)findViewById(R.id.updateapk);
		directionsText = (TextView)findViewById(R.id.directionstext);
		versionText = (TextView)findViewById(R.id.versioninfo);
		
		headtitle = (TextView) findViewById(R.id.shopname);
		headtitle.setText("版本更新");
		
		headmore = (ImageView) findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		
        findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		
		vsersionInfo = "已检测到最新版本：" + getIntent().getStringExtra("versionCode");
		dirvectionsList = getIntent().getStringArrayListExtra("directions");
		
		int i = 0;
		for(String info:dirvectionsList)
		{   
			i++;
			dirvectionsInfo += i+"."+info+"\n";
		}
		versionText.setText(vsersionInfo);
		directionsText.setText(dirvectionsInfo);
		
	}
}
