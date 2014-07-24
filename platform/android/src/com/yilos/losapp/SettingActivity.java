package com.yilos.losapp;

import java.util.ArrayList;
import java.util.List;

import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.bean.ServerVersionResponse;
import com.yilos.losapp.common.NetworkUtil;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class SettingActivity extends BaseActivity {

	private TextView headtitle;

	private ImageView headmore;

	private RelativeLayout linkShop;

	private RelativeLayout modfiypwd;

	private RelativeLayout aboutlos;

	private RelativeLayout versionUpdate;

	private RelativeLayout lgout;
	
	private TextView versiontext;
	
	private String verion;
	
	private ArrayList<String> versionDirections = new ArrayList<String>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting);

		initView();
		
		if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
		{
		  getNewVersion();
		}
		
	}

	final Handler handle = new Handler() {
		public void handleMessage(Message msg) 
		{
			if(msg.what==0)
			{
				versiontext.setText("检测到有新版本");
			}
			if(msg.what==1)
			{
				versiontext.setText("当前版本已是最新版本");
				versionUpdate.setEnabled(false);
			}
		}
	};

	public void getNewVersion() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerVersionResponse res = ac.checkVersion("1");
				if (res.isSucess()) {
					if("yes".equals(res.getResult().getHas_new_version()))
					{
						verion = res.getResult().getVersion_code();
						versionDirections = (ArrayList<String>) res.getResult().getFeature_descriptions();
						
						msg.what = 0;
					}else
					{
						msg.what = 1;
					}
				} else {
					msg.what = 2;
				}
				handle.sendMessage(msg);
			}
		}.start();
	}

	private void initView() {
		headtitle = (TextView) findViewById(R.id.shopname);
		headtitle.setText("设置");

		headmore = (ImageView) findViewById(R.id.headmore);
		headmore.setVisibility(View.GONE);

		findViewById(R.id.goback).setVisibility(View.GONE);

		linkShop = (RelativeLayout) findViewById(R.id.relativelayout_linkshop);
		modfiypwd = (RelativeLayout) findViewById(R.id.relativelayout_modfiypwd);
		aboutlos = (RelativeLayout) findViewById(R.id.relativelayout_aboutlos);
		lgout = (RelativeLayout) findViewById(R.id.relativelayout_lgout);
		versionUpdate = (RelativeLayout) findViewById(R.id.relativelayout_update);
		versiontext = (TextView)findViewById(R.id.versiontext);
		findViewById(R.id.goback).setVisibility(View.GONE);

		linkShop.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent linkshop = new Intent();
				linkshop.setClass(getBaseContext(), LinkShopActivity.class);
				startActivity(linkshop);
			}
		});

		modfiypwd.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent modifypwd = new Intent();
				modifypwd.setClass(getBaseContext(), ModifyPwdActivity.class);
				startActivity(modifypwd);

			}
		});

		aboutlos.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent aboutIntent = new Intent();
				aboutIntent.setClass(getBaseContext(), AboutLosActivity.class);
				startActivity(aboutIntent);
			}
		});

		versionUpdate.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent aboutIntent = new Intent();
				aboutIntent.putExtra("versionCode", verion);
				aboutIntent.putStringArrayListExtra("directions", versionDirections);
				
				aboutIntent.setClass(getBaseContext(),
						UpdateApkVersionActivity.class);
				startActivity(aboutIntent);
			}
		});

		lgout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				  
                
                //警告框  
                new AlertDialog.Builder(SettingActivity.this) 
                .setTitle("退出应用")  
                .setMessage("确定退出乐斯小秘书？")  
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {  
                    public void onClick(DialogInterface dialog, int which) {
                    	lgout();
                    }  
                })  
                .setNegativeButton("取消", new DialogInterface.OnClickListener() {    
                    public void onClick(DialogInterface dialog, int whichButton) {    
                    }    
                })  
                .create()  
                .show();  
			}
		});
	}
}
