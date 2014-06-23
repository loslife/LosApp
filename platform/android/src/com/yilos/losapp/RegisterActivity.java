package com.yilos.losapp;

import com.yilos.losapp.bean.ServerResponse;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class RegisterActivity extends Activity
{
	private EditText phoneNum;
	
	private EditText validatecode;
	
	private TextView reqValidatecode;
	
	private EditText password;
	
	private EditText confirmPwd;
	
	private TextView registration;
	
	private CountDownTimer countDownTimer;
	
	private boolean isUserExist = false;
	
	private boolean forgotpwd;

	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		Intent intent = this.getIntent();
		forgotpwd =intent.getBooleanExtra("forgotpwd", false);
		if(forgotpwd)
		{
			setContentView(R.layout.forgotpassword);
		}
		else
		{
			setContentView(R.layout.register);
		}
		
		initView();
	}
	
	public void initView()
	{
		phoneNum = (EditText)findViewById(R.id.phoneNum);
		validatecode = (EditText)findViewById(R.id.validatecode);
		reqValidatecode = (TextView)findViewById(R.id.btn_validatecode);
		password = (EditText)findViewById(R.id.password);
		confirmPwd = (EditText)findViewById(R.id.confirm_password);
		registration = (TextView)findViewById(R.id.btn_register);

		
		reqValidatecode.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入注册的手机号码");
				}
				else
				{
					getValidatecode(phoneNum.getText().toString());
				}
			}
		});
		
		registration.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				String code = validatecode.getText().toString();
				String pwd = password.getText().toString();
				String cPwd = confirmPwd.getText().toString();
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入注册的手机号码");
					return;
				}
				if(StringUtils.isEmpty(code))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入验证码");
					return;
				}
				
				if(StringUtils.isEmpty(pwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入密码");
					return;
				}
				if(StringUtils.isEmpty(cPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请再次确认输入密码");
					return;
				}
				if(!cPwd.equals(pwd))
				{
					UIHelper.ToastMessage(v.getContext(), "两次输入的密码不一致");
					return;
				}
				//校验验证码
				checkValidatecode(phoneNo,code);
				if(!StringUtils.isEmpty(code)&&forgotpwd)
				{
					//忘记密码
					if(checkMobileNumber(phoneNo))
					{
						
					}
				}
				else
				{
					//注册
					if(!checkMobileNumber(phoneNo))
					{
						userRegister(phoneNo,pwd);
					}
				}
				
			}
		});

	}
	
	/**
	 * 检查验证码
	 * @param vcode
	 */
	private void checkValidatecode(final String phoneNumber,final String vcode)
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==0)
				{
					validatecode.setText("");
					UIHelper.ToastMessage(RegisterActivity.this, "验证码错误，请重新输入");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.checkValidatecode(phoneNumber,"register_losapp",vcode);
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
	
	/**
	 * 检查用户是否存在
	 */
	private boolean checkMobileNumber(final String phoneNumber) 
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					isUserExist = true;
				}
				if(msg.what==0)
				{
					isUserExist = false;
					UIHelper.ToastMessage(RegisterActivity.this, "用户已存在");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.checkUserAccount(phoneNumber);
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
		return isUserExist;
	}
	
	/**
	 * 用户注册
	 * @param phoneNumber
	 * @param pwd
	 */
	private void userRegister(final String phoneNumber,final String pwd)
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					UIHelper.ToastMessage(RegisterActivity.this, "注册成功");
					Intent  register =  new Intent();
					register.setClass(RegisterActivity.this, LoginActivity.class);
					startActivity(register);
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(RegisterActivity.this, "注册失败");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.register(phoneNumber,pwd);
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
	
	/**
	 * 获取验证码
	 * @param phoneNumber
	 */
	private void getValidatecode(final String phoneNumber)
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					renderValidateCodeText();
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(RegisterActivity.this, "获取验证码失败");
				}
				
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerResponse res = ac.getValidatecode(phoneNumber);
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
	
	/**
	 * 刷下获取验证码的按钮
	 */
	private void renderValidateCodeText() {
		if (null == reqValidatecode) {
			return;
		}
		if (null != countDownTimer) {
			countDownTimer.cancel();
		}
		reqValidatecode.setEnabled(false);
		countDownTimer = new CountDownTimer(1000L * 60, 1000L) {
			int count = 60;

			@Override
			public void onFinish() {
				reqValidatecode.setEnabled(true);
				reqValidatecode.setText("获取验证码");
			}

			@Override
			public void onTick(long millisUntilFinished) {
				reqValidatecode.setText("(" + (--count) + ")"
						+ "后重新获取验证码");
			}
		};
		countDownTimer.start();
	}

}
