package com.yilos.secretary;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.MyShopBean;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.StringUtils;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.service.MemberService;
import com.yilos.secretary.service.MyshopManageService;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.ViewGroup; 
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
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
	private TextView title;

	private CountDownTimer countDownTimer;
	private MyshopManageService myshopService;
	private MemberService memberService;
	
	private List<MyShopBean> myshops;
	
	private List<MyShopBean> myDisconnectShops;
	
	private boolean isUserExist = false;
	private boolean isRecoveryLink = false;
	private String shopId;
	
	private String errorCode;
	public static final String OPRTATE_TYPE = "linkshop";
	
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
		findViewById(R.id.linkbar).setVisibility(View.GONE) ;
		headmore.setVisibility(View.GONE);
		inputlinkshop.setVisibility(View.GONE);
		title = (TextView)findViewById(R.id.shopname);
		title.setText("关联店铺");
		//设置店铺列表
		setShopListView();
		setUnShopListView();
		if(!(myshops.size()>0)&&!(myDisconnectShops.size()>0))
		{
			((LinearLayout)findViewById(R.id.noshop)).setVisibility(View.VISIBLE);
			inputlinkshop.setVisibility(View.GONE);
		}
		else
		{
			((LinearLayout)findViewById(R.id.noshop)).setVisibility(View.GONE);
		}
		
		findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});

		reqValidatecode.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				reqValidatecode.setEnabled(false);
				String phoneNo = phoneNum.getText().toString();
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入关联店铺的手机账号");
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
					}
				}
				reqValidatecode.setEnabled(true);
			}
		});
		
		linkshopbtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String phoneNo = phoneNum.getText().toString();
				String code = validatecode.getText().toString();
				linkshopbtn.setEnabled(false);
				if(StringUtils.isEmpty(phoneNo))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入关联店铺的手机账号");
					linkshopbtn.setEnabled(true);
					return;
				}
				if(StringUtils.isEmpty(code))
				{
					UIHelper.ToastMessage(v.getContext(), "请输入验证码");
					linkshopbtn.setEnabled(true);
					return;
				}
				
					if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
					{   
						findViewById(R.id.linkbar).setVisibility(View.VISIBLE) ;
						
						//校验验证码
						checkValidatecode(phoneNo,code);
						
					}
					else
					{
						UIHelper.ToastMessage(v.getContext(), "网络连接不可用，请检查网络设置");
						linkshopbtn.setEnabled(true);
						return;
					}
			}
		});
		
		linkshopinputbtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				if(inputlinkshop.getVisibility()!=View.GONE)
				{
					inputlinkshop.setVisibility(View.GONE);
					linkshopinputbtn.setText("添加关联");
					if(!(myshops.size()>0)&&!(myDisconnectShops.size()>0))
					{
						((LinearLayout)findViewById(R.id.noshop)).setVisibility(View.VISIBLE);
					}
					else
					{
						((LinearLayout)findViewById(R.id.noshop)).setVisibility(View.GONE);
					}
					
				}
				else
				{
					inputlinkshop.setVisibility(View.VISIBLE);
					linkshopinputbtn.setText("取消");
					((LinearLayout)findViewById(R.id.noshop)).setVisibility(View.GONE);
				}

			}
		});
	}
	
	private void setShopListView()
	{
		//绑定Layout里面的ListView  
        ListView list = (ListView) findViewById(R.id.shoplist);  
        myshops = myshopService.queryShops();
        if(myshops.size()>0)
        {
        	((View)findViewById(R.id.shoplist_midview)).setVisibility(View.VISIBLE);
        }
        else
        {
        	((View)findViewById(R.id.shoplist_midview)).setVisibility(View.GONE);
        }
          
        //生成动态数组，加入数据  
        ArrayList<HashMap<String, Object>> listItem = new ArrayList<HashMap<String, Object>>();  
        for(MyShopBean bean:myshops)  
        {  
        	String shopName = bean.getEnterprise_name()==null?"":bean.getEnterprise_name();
        	if(shopName!=null&&shopName.length()>10)
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
        )
        {  
            //在这个重写的函数里设置 每个 item 中按钮的响应事件  
            @Override  
            public View getView(int position, View convertView,ViewGroup parent) {  
                final int p=position;  
                final View view=super.getView(position, convertView, parent);  
                final TextView button=(TextView)view.findViewById(R.id.linkbtn);  
                ((ProgressBar)view.findViewById(R.id.listbar)).setVisibility(View.GONE) ;
                button.setOnClickListener(new OnClickListener() {  
                      
                    @Override  
                    public void onClick(View v) {  
                          
                        //警告框  
                        new AlertDialog.Builder(LinkShopActivity.this)  
                        .setTitle("解除关联")  
                        .setMessage("解除关联后，您将看不到<"+myshops.get(p).getEnterprise_name()+">的任何信息，是否解除？")  
                        .setPositiveButton("是", new DialogInterface.OnClickListener() {  
                            public void onClick(DialogInterface dialog, int which) {
                            	if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
            					{ 
                            		((ProgressBar)view.findViewById(R.id.listbar)).setVisibility(View.VISIBLE) ;
                                	unlinkShop(AppContext.getInstance(getBaseContext()).getUserAccount(), myshops.get(p).getEnterprise_id());
            					}
                            	else
            					{
                            		UIHelper.ToastMessage(getBaseContext(), "网络连接不可用，请检查网络设置");
            					}
                            }  
                        })  
                        .setNegativeButton("否", new DialogInterface.OnClickListener() {    
                            public void onClick(DialogInterface dialog, int whichButton) {    
                            }    
                        })  
                        .create()  
                        .show();  
                    }  
                });  
                return view;  
            }  
    };  
        //添加并且显示  
        list.setAdapter(listItemAdapter); 
	}
	
	
	private void setUnShopListView()
	{
		//绑定Layout里面的ListView  
        ListView list = (ListView) findViewById(R.id.unshoplist);  
        myDisconnectShops = myshopService.queryUnLinkshop();
        if(myDisconnectShops.size()>0)
        {
        	((View)findViewById(R.id.unshoplist_midview)).setVisibility(View.VISIBLE);
        }
        else
        {
        	((View)findViewById(R.id.unshoplist_midview)).setVisibility(View.GONE);
        }
        //生成动态数组，加入数据  
        ArrayList<HashMap<String, Object>> listItem = new ArrayList<HashMap<String, Object>>();  
        for(MyShopBean bean:myDisconnectShops)  
        {  
        	String shopName = bean.getEnterprise_name()==null?"":bean.getEnterprise_name();
        	if(shopName!=null&&shopName.length()>10)
        	{
        		shopName = shopName.substring(0, 10)+"...";
        	}
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("linkicon", R.drawable.unlinkicon);  
            map.put("linkshopname", shopName);  
            listItem.add(map);  
        } 
        
        //生成适配器的Item和动态数组对应的元素  
        SimpleAdapter listItemAdapter = new SimpleAdapter(this,listItem,//数据源   
            R.layout.shop_item,//ListItem的XML实现  
            //动态数组与ImageItem对应的子项          
            new String[] {"linkicon","linkshopname"},   
            //ImageItem的XML文件里面的一个ImageView,两个TextView ID  
            new int[] {R.id.linkicon,R.id.linkshopname}  
        )
        {  
            //在这个重写的函数里设置 每个 item 中按钮的响应事件  
            @Override  
            public View getView(int position, View convertView,ViewGroup parent) {  
                final int p=position;  
                final View view=super.getView(position, convertView, parent);  
                final TextView button=(TextView)view.findViewById(R.id.linkbtn); 
                button.setText("恢复关联");
                button.setBackgroundResource(R.drawable.login_btn);
                ((ProgressBar)view.findViewById(R.id.listbar)).setVisibility(View.GONE) ;
                button.setOnClickListener(new OnClickListener() {  
                      
                    @Override  
                    public void onClick(View v) {  
                          
                        //警告框  
                        new AlertDialog.Builder(LinkShopActivity.this)  
                        .setTitle("恢复关联")  
                        .setMessage("是否恢复对<"+myDisconnectShops.get(p).getEnterprise_name()+">的关联？")  
                        .setPositiveButton("是", new DialogInterface.OnClickListener() {  
                            public void onClick(DialogInterface dialog, int which) {
                            	if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
            					{ 
                            		isRecoveryLink = true;
                                	((ProgressBar)view.findViewById(R.id.listbar)).setVisibility(View.VISIBLE) ;
                                	linkShop(AppContext.getInstance(getBaseContext()).getUserAccount(), myDisconnectShops.get(p).getEnterprise_account());
                                	if(AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId()==null)
                					{
                						AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
                						AppContext.getInstance(getBaseContext()).setShopName(myDisconnectShops.get(p).getEnterprise_name());
                					}
            					}
                            	else
                            	{
                            		UIHelper.ToastMessage(getBaseContext(), "网络连接不可用，请检查网络设置");
                            	}
                            }  
                        })  
                        .setNegativeButton("否", new DialogInterface.OnClickListener() {    
                            public void onClick(DialogInterface dialog, int whichButton) {    
                            }    
                        })  
                        .create()  
                        .show();  
                    }  
                });  
                return view;  
            }  
    };  
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
					setUnShopListView();
					UIHelper.ToastMessage(getBaseContext(), "关联成功");
					phoneNum.setText("");
					validatecode.setText("");
				}
				if(msg.what==0)
				{
					//设置店铺列表
					setShopListView();
					setUnShopListView();
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString(OPRTATE_TYPE, errorCode));
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
					shopId = res.getResult().getEnterprise_id();
					MyShopBean myshop = new MyShopBean();
					myshop.setEnterprise_id(shopId);
					myshop.setEnterprise_name(res.getResult().getEnterprise_name());
					myshop.setEnterprise_account(shopAccount);
					if(isRecoveryLink)
					{
						myshopService.modifyDisplay(shopId, "0");
						isRecoveryLink = false;
					}
					else
					{
						myshopService.addShop(myshop);	
					}

					if(AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId()==null)
					{
						AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(shopId);
						AppContext.getInstance(getBaseContext()).setChangeShop(true);
					}
					
					if(AppContext.getInstance(getBaseContext()).getShopName()==null)
					{
						AppContext.getInstance(getBaseContext()).setShopName(myshop.getEnterprise_name());
					}
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
	
	private void unlinkShop(final String userAccount,final String shopid)
	{
		myshopService = new MyshopManageService(getBaseContext());
		final Handler handle =new Handler(){
			public void handleMessage(Message msg)
			{
				if(msg.what==1)
				{
					//设置店铺列表
					myshopService.modifyDisplay(shopid, "1");
					setShopListView();
					setUnShopListView();
					UIHelper.ToastMessage(getBaseContext(), "解除关联成功");
					myshops = myshopService.queryShops();
				    if(!(myshops.size()>0))
				    {
				    	AppContext.getInstance(getBaseContext()).setCurrentDisplayShopId(null);
				    	AppContext.getInstance(getBaseContext()).setChangeShop(true);
				    }
				    
				    if(shopid.equals(AppContext.getInstance(getBaseContext()).getCurrentDisplayShopId()))
				    {
				    	AppContext.getInstance(getBaseContext()).setChangeShop(true);
				    }
				   
				}
				if(msg.what==0)
				{
					//设置店铺列表
					setShopListView();
					setUnShopListView();
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString("undolinkshop", errorCode));
				}
			}
		};
		new Thread()
		{
			public void run(){
				AppContext ac = (AppContext)getApplication(); 
				Message msg = new Message();
				ServerMemberResponse res = ac.undoLinkshop(userAccount, shopid);
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
				reqValidatecode.setEnabled(true);
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
					errorCode = res.getResult().getErrorCode();
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
				if(msg.what==1)
				{
					  linkShop(AppContext.getInstance(getBaseContext()).getUserAccount(),phoneNumber);
				}
				
				if(msg.what==0)
				{
					UIHelper.ToastMessage(getBaseContext(), StringUtils.errorcodeToString("checkValidatecode", errorCode));
				}
				linkshopbtn.setEnabled(true);
				findViewById(R.id.linkbar).setVisibility(View.GONE) ;
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
					errorCode = res.getResult().getErrorCode();
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
				reqValidatecode.setText("获取验证码");
				((View)findViewById(R.id.viewline)).setVisibility(View.VISIBLE);
				reqValidatecode.setTextColor(getBaseContext().getResources().getColor(R.color.blue_text));
			}

			@Override
			public void onTick(long millisUntilFinished) {
				reqValidatecode.setText((--count) 
						+ "秒重发");
				((View)findViewById(R.id.viewline)).setVisibility(View.GONE);
				reqValidatecode.setTextColor(getBaseContext().getResources().getColor(R.color.gray_text));
			}
		};
		countDownTimer.start();
	}

}
