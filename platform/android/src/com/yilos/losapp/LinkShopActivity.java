package com.yilos.losapp;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;

public class LinkShopActivity extends Activity
{
    private EditText phoneNum;
	
	private EditText validatecode;
	private TextView reqValidatecode;
	private TextView linkshopbtn;
	
	private CountDownTimer countDownTimer;
	private MyshopManageService myshopService;
	
	private boolean isUserExist = false;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.linkshop);
		initView();
	}
	
	public void initView()
	{
		phoneNum = (EditText)findViewById(R.id.phoneNum);
		validatecode = (EditText)findViewById(R.id.validatecode);
		reqValidatecode = (TextView)findViewById(R.id.btn_validatecode);
		linkshopbtn = (TextView)findViewById(R.id.linkshopbtn);
		reqValidatecode.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入关联店铺的手机账号");
				}
				else
				{
					getValidatecode(phoneNum.getText().toString());
				}
			}
		});
		
		linkshopbtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				String code = validatecode.getText().toString();
			
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
				
				
				//校验验证码
				checkValidatecode(phoneNo,code);
				
				if(!StringUtils.isEmpty(code))
				{
						linkShop(AppContext.getInstance(getBaseContext()).getUserAccount(),phoneNo);
				}
				
			}
		});
	}
	
	private void linkShop(final String userAccount,final String shopAccount)
	{
		myshopService = new MyshopManageService(getBaseContext());
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					UIHelper.ToastMessage(getBaseContext(), "关联成功");
				}
				if(msg.what==0)
				{
					UIHelper.ToastMessage(getBaseContext(), "关联失败");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.linkshop(userAccount, shopAccount);
				if(res.isSucess())
				{
					MyShopBean myshop = new MyShopBean();
					myshop.setEnterprise_id(res.getResult().getEnterprise_id());
					myshop.setEnterprise_name(res.getResult().getEnterprise_name());
					myshopService.addShop(myshop);
					
					if(AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId()==null)
					{
						AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(res.getResult().getEnterprise_id());
					}
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
	private boolean checkShopAccount(final String phoneNumber) 
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
					UIHelper.ToastMessage(getBaseContext(), "关联的店铺不存在");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.checkShopAccount(phoneNumber);
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
					UIHelper.ToastMessage(LinkShopActivity.this, "获取验证码失败");
				}
				
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.getValidatecode(phoneNumber,"attach");
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
					UIHelper.ToastMessage(LinkShopActivity.this, "验证码错误，请重新输入");
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.checkValidatecode(phoneNumber,"attach",vcode);
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
