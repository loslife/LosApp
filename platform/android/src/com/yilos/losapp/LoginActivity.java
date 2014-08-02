package com.yilos.losapp;

import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.NetworkUtil;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.database.SDBHelper;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class LoginActivity extends BaseActivity{
	
	private EditText userNameExt;
	
	private EditText pwdExt;
	
	private TextView loginBtn;
	
	private TextView findPassword;
	
	private TextView shopName;
	
	private String errorCode;
	public static final String OPRTATE_TYPE = "login";
	
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		initView();
	}
	
	private void initView()
	{
		userNameExt = (EditText)findViewById(R.id.et_user_name);
		pwdExt = (EditText)findViewById(R.id.et_user_pwd);
		loginBtn = (TextView)findViewById(R.id.btn_signin);
		findPassword = (TextView)findViewById(R.id.tv_forgot_password);
		shopName = (TextView)findViewById(R.id.shopname);
		shopName.setText("登录");
		
		findViewById(R.id.headmore).setVisibility(View.GONE);
		
		if(getIntent().getStringExtra("phoneNumber")!=null)
		{
			userNameExt.setText(getIntent().getStringExtra("phoneNumber"));
		}
		
		
		findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					finish();
				}
			});
		
		findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		
		
		loginBtn.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				loginBtn.setEnabled(false);
				String account = userNameExt.getText().toString();
				String pwd = pwdExt.getText().toString();
				//判断输入
				if(StringUtils.isEmpty(account)){
					UIHelper.ToastMessage(v.getContext(), "请输入用户名");
					return;
				}
				if(StringUtils.isEmpty(pwd)){
					UIHelper.ToastMessage(v.getContext(), "请输入密码");
					return;
				}
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					loginUser(account,pwd);
				}
				else
				{
					UIHelper.ToastMessage(v.getContext(), "当前网络不佳，请检查网络");
					return;
				}
				
				//跳转到主界面
				/*Intent main = new Intent();
				main.setClass(LoginActivity.this, MainTabActivity.class);
				startActivity(main);*/
			}
		});
		
		
		findPassword.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent forgotpwd = new Intent();
				forgotpwd.setClass(LoginActivity.this, RegisterActivity.class);
				forgotpwd.putExtra("forgotpwd", true);
				startActivity(forgotpwd);
			}
		});
	}
	
	private void loginUser(final String userName,final String pwd)
	{
		final Handler handle = new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what== 1)
				{
					//提示登录成功
					
					AppContext.getInstance(getBaseContext()).setUserAccount(userName);
					//跳转到主界面
					Intent main = new Intent();
					main.setClass(LoginActivity.this, LaunchActivity.class);
					startActivity(main);
				}
				else
				{
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString(OPRTATE_TYPE, errorCode));
				}
				loginBtn.setEnabled(true);
			}
		};
		new Thread(){
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.loginVerify(userName, pwd);
				if(res.isSucess())
				{
					msg.what = 1;
				}
				if(res.getCode()==1)
				{
					msg.what = 0;
					errorCode = res.getResult().getErrorCode();
				}
				
				handle.sendMessage(msg);
			}
		}.start();
	}

}
