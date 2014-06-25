package com.yilos.losapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;

import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;

public class ModifyPwdActivity  extends Activity
{

	private EditText oldPassword;
	
	private EditText newPassword;
	
	private EditText confirmPwd;
	
	private TextView modifybtn;


	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		Intent intent = this.getIntent();
		setContentView(R.layout.modifypwd);
	
		
		initView();
	}
	
	public void initView()
	{
		oldPassword = (EditText)findViewById(R.id.oldPassword);
		newPassword = (EditText)findViewById(R.id.newpassword);
		confirmPwd = (EditText)findViewById(R.id.confirm_newpassword);
		modifybtn = (TextView)findViewById(R.id.btn_modifypwd);

		modifybtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = AppContext.getInstance(getBaseContext()).getUserAccount();

				String oldpwd = oldPassword.getText().toString();
				String newPwd = newPassword.getText().toString();
				String cPwd = confirmPwd.getText().toString();

				if(StringUtils.isEmpty(oldpwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入原始密码");
					return;
				}
				if(StringUtils.isEmpty(newPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入新密码");
					return;
				}
				if(StringUtils.isEmpty(cPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请再次确认输入密码");
					return;
				}
				if(!cPwd.equals(newPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "两次输入的新密码不一致");
					return;
				}
				
				modifyPwd(phoneNo,oldpwd,newPwd);
					
				}
	
		});

	}
	
	
	
	/**
	 * 用户修改密码
	 * @param phoneNumber
	 * @param pwd
	 */
	private void modifyPwd(final String phoneNumber,final String pwd,final String newpwd)
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					UIHelper.ToastMessage(ModifyPwdActivity.this, "修改密码成功");
					
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(ModifyPwdActivity.this, "修改密码失败");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.modifyPwd(phoneNumber,pwd,newpwd);
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
