package com.yilos.losapp;




import com.yilos.losapp.api.ApiClient;
import com.yilos.losapp.bean.Result;
import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class LoginActivity extends Activity{
	
	private EditText userNameExt;
	
	private EditText pwdExt;
	
	private Button loginBtn;
	
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
				loginUser(account,pwd);
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
					//保存登录信息
					
					//提示登录成功
					UIHelper.ToastMessage(LoginActivity.this, "登录成功");
					//跳转到主界面
					Intent main = new Intent();
					main.setClass(LoginActivity.this, Main.class);
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
				ServerResponse res = ac.loginVerify(userName, pwd);
				
				if(res.isSucess())
				{
					msg.what = 1;
				}
				
				handle.sendMessage(msg);
			}
		}.start();
	}

}
