package com.yilos.secretary;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.common.StringUtils;
import com.yilos.secretary.common.UIHelper;

public class ModifyPwdActivity  extends BaseActivity
{

	private EditText oldPassword;
	
	private EditText newPassword;
	
	private EditText confirmPwd;
	
	private TextView modifybtn;
	
	private ImageView headmore;
	
	private TextView  shopname;


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
		shopname = (TextView)findViewById(R.id.shopname);
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		shopname.setText("修改密码");
		
       findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
			}
		});

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
					modifybtn.setEnabled(false);
					return;
				}
				if(StringUtils.isEmpty(newPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入新密码");
					modifybtn.setEnabled(false);
					return;
				}
				if(StringUtils.isEmpty(cPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请再次确认输入密码");
					modifybtn.setEnabled(false);
					return;
				}
				if(!cPwd.equals(newPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "两次输入的新密码不一致");
					modifybtn.setEnabled(false);
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
					oldPassword.setText("");
					newPassword.setText("");
					confirmPwd.setText("");
					UIHelper.ToastMessage(ModifyPwdActivity.this, "修改密码成功");
					
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(ModifyPwdActivity.this, "修改密码失败");
				}
				modifybtn.setEnabled(true);
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.modifyPwd(phoneNumber,pwd,newpwd);
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
