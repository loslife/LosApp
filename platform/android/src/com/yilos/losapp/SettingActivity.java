package com.yilos.losapp;


import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class SettingActivity extends Activity{

	private TextView headtitle;
	
	private ImageView  headmore;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting);
		
		initView();
		
	}
	
	private void initView()
	{
		headtitle = (TextView)findViewById(R.id.headtitle);
		headtitle.setText("设置");
		
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
	}
}
