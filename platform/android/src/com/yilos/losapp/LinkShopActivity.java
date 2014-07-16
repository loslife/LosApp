package com.yilos.losapp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.MemberService;
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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class LinkShopActivity extends BaseActivity
{
    private EditText phoneNum;
	
	private EditText validatecode;
	private TextView reqValidatecode;
	private TextView linkshopbtn;
	private LinearLayout  inputlinkshop;
	private TextView linkshopinputbtn;
	private ImageView  headmore;
	
	private CountDownTimer countDownTimer;
	private MyshopManageService myshopService;
	private MemberService memberService;
	
	private List<MyShopBean> myshops;
	
	private boolean isUserExist = false;
	private String shopId;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.linkshop);
		myshopService = new MyshopManageService(getBaseContext());
		initView();
		
	}
	
	public void initView()
	{
		phoneNum = (EditText)findViewById(R.id.phoneNum);
		validatecode = (EditText)findViewById(R.id.validatecode);
		reqValidatecode = (TextView)findViewById(R.id.btn_validatecode);
		linkshopbtn = (TextView)findViewById(R.id.linkshopbtn);
		inputlinkshop = (LinearLayout)findViewById(R.id.inputlinkshop);
		linkshopinputbtn = (TextView)findViewById(R.id.linkshopinputbtn);
		headmore = (ImageView)findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);
		
		//设置店铺列表
		setShopListView();
		
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
		
		linkshopinputbtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				if(inputlinkshop.getVisibility()!=View.GONE)
				{
					inputlinkshop.setVisibility(View.GONE);
					linkshopinputbtn.setText("关联店铺");
				}
				else
				{
					inputlinkshop.setVisibility(View.VISIBLE);
					linkshopinputbtn.setText("取消");
				}
				
			}
		});
	}
	
	private void setShopListView()
	{
		//绑定Layout里面的ListView  
        ListView list = (ListView) findViewById(R.id.shoplist);  
        myshops = myshopService.queryShops();
          
        //生成动态数组，加入数据  
        ArrayList<HashMap<String, Object>> listItem = new ArrayList<HashMap<String, Object>>();  
        for(MyShopBean bean:myshops)  
        {  
        	String shopName = bean.getEnterprise_name();
        	if(shopName.length()>10)
        	{
        		shopName = shopName.substring(0, 10)+"...";
        	}
            HashMap<String, Object> map = new HashMap<String, Object>();  
            map.put("linkshopname", shopName);  
            listItem.add(map);  
        } 
        
        //生成适配器的Item和动态数组对应的元素  
        SimpleAdapter listItemAdapter = new SimpleAdapter(this,listItem,//数据源   
            R.layout.shop_item,//ListItem的XML实现  
            //动态数组与ImageItem对应的子项          
            new String[] {"linkshopname"},   
            //ImageItem的XML文件里面的一个ImageView,两个TextView ID  
            new int[] {R.id.linkshopname}  
        );  
         
        //添加并且显示  
        list.setAdapter(listItemAdapter); 
	}
	
	private void linkShop(final String userAccount,final String shopAccount)
	{
		myshopService = new MyshopManageService(getBaseContext());
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					//getMemberContact(shopId);
					//设置店铺列表
					setShopListView();
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
					shopId = res.getResult().getEnterprise_id();
					myshop.setEnterprise_id(shopId);
					myshop.setEnterprise_name(res.getResult().getEnterprise_name());
					myshopService.addShop(myshop);
					
					if(AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId()==null)
					{
						AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
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
	
	public void getMemberContact(final String shopId) {

		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();

				ServerMemberResponse res = ac.getMembersContacts(shopId, "0");
				if (res.isSucess()) {
					AppContext.getInstance(getBaseContext())
					.setCurrentDisplayShopId(shopId);
					memberService.handleMembers(res.getResult().getRecords());
					String last_sync = String.valueOf(res.getResult().getLast_sync());
					myshopService.updateLatestSync(last_sync, shopId,
							"Contacts");
					AppContext.getInstance(getBaseContext())
							.setContactLastSyncTime(last_sync);
				}
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
