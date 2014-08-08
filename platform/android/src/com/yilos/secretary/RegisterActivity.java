package com.yilos.secretary;

import android.R.color;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.StringUtils;
import com.yilos.secretary.common.UIHelper;

public class RegisterActivity extends BaseActivity
{
	private EditText phoneNum;
	
	private EditText validatecode;
	
	private TextView reqValidatecode;
	
	private EditText password;
	
	private EditText confirmPwd;
	
	private TextView registration;
	
	private TextView system_vcode_tip;
	
	private TextView operat_next;
	
	private TextView timecount;
	
	private CountDownTimer countDownTimer;
	
	private LinearLayout checkvcodelayout;
	
	private LinearLayout registerlayout;
	
    private RelativeLayout layout_getcode;
	
	private RelativeLayout layout_codetip;
	
	private RelativeLayout relativelayout_vcode;
	
	private ImageView  headmore;
	
	private TextView shopName;
	
	private boolean isUserExist = false;
	
	private boolean forgotpwd;
	
    private static final String REGISTER = "register";
    
    private static final String FIND_PWD = "findpwd";
	
	private String errorCode;

	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		Intent intent = this.getIntent();
		forgotpwd =intent.getBooleanExtra("forgotpwd", false);
		shopName = (TextView)findViewById(R.id.shopname);
		
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
	
	@SuppressLint("ResourceAsColor")
	public void initView()
	{
		phoneNum = (EditText)findViewById(R.id.phoneNum);
		validatecode = (EditText)findViewById(R.id.validatecode);
		reqValidatecode = (TextView)findViewById(R.id.btn_validatecode);
		system_vcode_tip = (TextView)findViewById(R.id.system_vcode_tip);
		password = (EditText)findViewById(R.id.password);
		confirmPwd = (EditText)findViewById(R.id.confirm_password);
		registration = (TextView)findViewById(R.id.btn_register);
		checkvcodelayout = (LinearLayout)findViewById(R.id.checkvcodelayout);
		registerlayout = (LinearLayout)findViewById(R.id.registerlayout);
		operat_next = (TextView)findViewById(R.id.operat_next);
		layout_getcode = (RelativeLayout)findViewById(R.id.layout_getcode);
		layout_codetip = (RelativeLayout)findViewById(R.id.layout_codetip);
		relativelayout_vcode = (RelativeLayout)findViewById(R.id.relativelayout_vcode);
		timecount = (TextView)findViewById(R.id.timecount);
		operat_next.setEnabled(false);
		operat_next.setBackgroundResource(R.drawable.gray_btn);
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		
        shopName = (TextView)findViewById(R.id.shopname);
		
		if(forgotpwd)
		{
			shopName.setText("找回密码");
		}
		else
		{
			shopName.setText("注册");
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
		
		reqValidatecode.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				reqValidatecode.setEnabled(false);
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入注册的手机号码");
					reqValidatecode.setEnabled(true);
					return;
				}
				else
				{
					if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
					{
					  getValidatecode(phoneNum.getText().toString());
					}
					else
					{
						UIHelper.ToastMessage(v.getContext(), "网络连接不可用，请检查网络设置");
						reqValidatecode.setEnabled(true);
						return;
					}
				}
			}
		});
		
		validatecode.addTextChangedListener(new TextWatcher() {

			@Override
			public void afterTextChanged(Editable s) {

			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {

			}
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				if(!"".equals(s))
				{
					operat_next.setEnabled(true);
					operat_next.setBackgroundResource(R.drawable.login_btn);
				}
				else
				{
					operat_next.setEnabled(false);
					operat_next.setBackgroundResource(R.drawable.gray_btn);
				}
			}

		});
		
		operat_next.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				String code = validatecode.getText().toString();
				operat_next.setEnabled(false);
				
				
				
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入注册的手机号码");
					operat_next.setEnabled(true);
					return;
				}
				
				//短信验证码好像罢工了，请确认输入是您本人号码，以确保使用中的账号与数据安全
				if(relativelayout_vcode.getVisibility()==View.GONE)
				{
					checkvcodelayout.setVisibility(View.GONE);
					registerlayout.setVisibility(View.VISIBLE);
					operat_next.setEnabled(true);
					return;
				}
				
				if(StringUtils.isEmpty(code))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入验证码");
					operat_next.setEnabled(true);
					return;
				}
				
				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					//校验验证码
					checkValidatecode(phoneNo,code);
				}
				else
				{
					UIHelper.ToastMessage(v.getContext(), "网络连接不可用，请检查网络设置");
					operat_next.setEnabled(true);
				}

			}
			
		});
		
		registration.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				String pwd = password.getText().toString();
				String cPwd = confirmPwd.getText().toString();
				String phoneNo = phoneNum.getText().toString();
				registration.setEnabled(false);
				if(StringUtils.isEmpty(pwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入密码");
					registration.setEnabled(true);
					return;
				}
				if(StringUtils.isEmpty(cPwd))
				{
					UIHelper.ToastMessage(v.getContext(), "请再次确认输入密码");
					registration.setEnabled(true);
					return;
				}
				if(!cPwd.equals(pwd))
				{
					UIHelper.ToastMessage(v.getContext(), "两次输入的密码不一致");
					registration.setEnabled(true);
					return;
				}

				if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
				{
					//注册
					if(!forgotpwd&&!checkMobileNumber(phoneNo))
					{
						userRegister(phoneNo,pwd);
					}
					//忘记密码
					if(forgotpwd&&checkMobileNumber(phoneNo))
					{
						forgotPwd(phoneNo,pwd);
					}
					
				}
				else
				{
					UIHelper.ToastMessage(v.getContext(), "网络连接不可用，请检查网络设置");
					registration.setEnabled(true);
					return;
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
				if(msg.what==1)
				{
					checkvcodelayout.setVisibility(View.GONE);
					registerlayout.setVisibility(View.VISIBLE);
				}
				if(msg.what==0)
				{
					
					validatecode.setText("");
					UIHelper.ToastMessage(RegisterActivity.this, "验证码错误，请重新输入");
				}
				operat_next.setEnabled(true);
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.checkValidatecode(phoneNumber,"register_losapp",vcode);
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
				ServerMemberResponse res = ac.checkUserAccount(phoneNumber);
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
					register.putExtra("phoneNumber", phoneNumber);
					register.setClass(RegisterActivity.this, LoginActivity.class);
					startActivity(register);
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString(REGISTER, errorCode));
				}
				registration.setEnabled(true);
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.register(phoneNumber,pwd);
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
	
	public  void forgotPwd(final String phoneNumber,final String pwd)
	{
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					UIHelper.ToastMessage(RegisterActivity.this, "找回成功");
					Intent  findPwd =  new Intent();
					findPwd.putExtra("phoneNumber", phoneNumber);
					findPwd.setClass(RegisterActivity.this, LoginActivity.class);
					startActivity(findPwd);
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString(FIND_PWD, errorCode));
				}
				registration.setEnabled(true);
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.findPwd(phoneNumber,pwd);
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
				reqValidatecode.setEnabled(true);
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.getValidatecode(phoneNumber,"register_losapp");
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
		countDownTimer = new CountDownTimer(1000L * 90, 1000L) {
			int count = 90;

			@Override
			public void onFinish() {
				if(!forgotpwd)
				{
					relativelayout_vcode.setVisibility(View.GONE);
					system_vcode_tip.setTextColor(getBaseContext().getResources().getColor(R.color.red));
					system_vcode_tip.setText("短信验证码好像罢工了，请确认输入是您本人号码，以确保使用中的账号与数据安全。");
					operat_next.setEnabled(true);
					operat_next.setBackgroundResource(R.drawable.login_btn);
				}
				else
				{
					layout_getcode.setVisibility(View.VISIBLE);
					layout_codetip.setVisibility(View.GONE);
				}
				
				timecount.setVisibility(View.GONE);
			}

			@Override
			public void onTick(long millisUntilFinished) {
				layout_getcode.setVisibility(View.GONE);
				layout_codetip.setVisibility(View.VISIBLE);
				system_vcode_tip.setText("系统已发送验证码，接收短信大约需要");
				timecount.setText((--count) 
						+ "秒");
			}
		};
		countDownTimer.start();
	}
	
	@Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {  
        if (keyCode == KeyEvent.KEYCODE_BACK) {  
            return false;  
        } else {  
            return super.onKeyDown(keyCode, event);  
        }  
    }  

}
