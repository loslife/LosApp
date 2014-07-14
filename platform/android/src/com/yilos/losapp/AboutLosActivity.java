package com.yilos.losapp;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

public class AboutLosActivity extends BaseActivity
{
	
	private TextView headtitle;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.abloutlos);
		
		initView();
	}

	private void initView()
	{
		headtitle = (TextView)findViewById(R.id.shopname);
		headtitle.setText("关于乐斯");
		
		findViewById(R.id.headmore).setVisibility(View.GONE);
		
        findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}
}
