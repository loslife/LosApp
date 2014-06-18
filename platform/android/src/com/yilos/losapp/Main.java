package com.yilos.losapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

public class Main extends Activity
{

	private TextView operate;
	
	private TextView contacts;
	
	private TextView setting;
	
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initFootBar();
	}
	
	/**
	 * 初始化底部栏
	 */
	private void initFootBar() {

		operate = (TextView)findViewById(R.id.operate);
		
		contacts = (TextView)findViewById(R.id.contacts);
		
		setting = (TextView)findViewById(R.id.setting);
		
		contacts.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), MemberGoupActivity.class);
				startActivity(contacts);
			}
		});

	}

}
