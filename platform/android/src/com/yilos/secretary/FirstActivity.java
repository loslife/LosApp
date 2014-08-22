package com.yilos.secretary;

import com.yilos.secretary.R;
import com.yilos.secretary.common.UIHelper;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

public class FirstActivity extends BaseActivity
{
    private TextView loginBtn;
	
	private TextView registration;
	
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.first);
		
		boolean isLogin = AppContext.getInstance(getBaseContext()).isLogin();
		if(isLogin)
		{
			Intent loginIntent = new Intent();
			loginIntent.setClass(getBaseContext(), LaunchActivity.class);
			loginIntent.putExtra("forwardClass", "FirstActivity");
			startActivity(loginIntent);
		}
		else
		{
			initView();	
		}
		
	}
	
	private void initView()
	{
		loginBtn = (TextView)findViewById(R.id.btn_login);
		registration = (TextView)findViewById(R.id.btn_register);
		
		loginBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent loginIntent = new Intent();
				loginIntent.setClass(getBaseContext(), LoginActivity.class);
				startActivity(loginIntent);
			}
		});
		
		registration.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent registIntent = new Intent();
				registIntent.setClass(getBaseContext(), RegisterActivity.class);
				startActivity(registIntent);
			}
		});
	}
}
