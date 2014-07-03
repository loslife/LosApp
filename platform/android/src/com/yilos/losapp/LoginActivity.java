package com.yilos.losapp;

import com.yilos.losapp.bean.ServerMemberResponse;
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
import android.widget.TextView;

public class LoginActivity extends Activity{
	
	private EditText userNameExt;
	
	private EditText pwdExt;
	
	private Button loginBtn;
	
	private TextView registration;
	
	private TextView findPassword;
	
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
		loginBtn = (Button)findViewById(R.id.btn_signin);
		registration = (TextView)findViewById(R.id.tv_registration);
		findPassword = (TextView)findViewById(R.id.tv_forgot_password);
		
		loginBtn.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
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
				//loginUser(account,pwd);
				//跳转到主界面
				Intent main = new Intent();
				main.setClass(LoginActivity.this, MainTabActivity.class);
				startActivity(main);
			}
		});
		
		registration.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent register = new Intent();
				register.setClass(LoginActivity.this, RegisterActivity.class);
				register.putExtra("forgotpwd", false);
				startActivity(register);
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
				else if(msg.what == 0)
				{
					UIHelper.ToastMessage(LoginActivity.this, "登录失败");
				}
				else if(msg.what == -1)
				{
					UIHelper.ToastMessage(LoginActivity.this, "登录异常");
				}
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
				}
				
				handle.sendMessage(msg);
			}
		}.start();
	}

}
