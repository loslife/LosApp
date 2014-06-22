package com.yilos.losapp;


import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class SettingActivity extends Activity{

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
		headtitle = (TextView)findViewById(R.id.headtitle);
		headtitle.setText("设置");
		
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		
		linkShop = (RelativeLayout)findViewById(R.id.relativelayout_linkshop);
		modfiypwd = (RelativeLayout)findViewById(R.id.relativelayout_modfiypwd);
		aboutlos = (RelativeLayout)findViewById(R.id.relativelayout_aboutlos);
	}
}
