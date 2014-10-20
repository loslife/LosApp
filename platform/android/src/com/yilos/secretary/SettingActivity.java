package com.yilos.secretary;

import java.util.ArrayList;
import java.util.List;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.ServerMemberResponse;
import com.yilos.secretary.bean.ServerVersionResponse;
import com.yilos.secretary.common.Constants;
import com.yilos.secretary.common.NetworkUtil;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
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
	
	private ImageView versionIcon;
	
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
				versionIcon.setImageDrawable(getBaseContext().getResources()
						.getDrawable(R.drawable.red_dot));
				versionUpdate.setEnabled(true);
			}
			if(msg.what==1)
			{
				versionIcon.setImageDrawable(getBaseContext().getResources()
						.getDrawable(R.drawable.righticon));
				versionUpdate.setEnabled(false);
			}
		}
	};

	public void getNewVersion() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				versionUpdate.setEnabled(false);
				ServerVersionResponse res = ac.checkVersion(Constants.VERSION);
				if (res.isSucess()) {
					if("yes".equals(res.getResult().getHas_new_version()))
					{
						verion = res.getResult().getVersion_code();
						versionDirections = (ArrayList<String>) res.getResult().getFeature_descriptions();
						
						msg.what = 0;
					}else
					{
						verion =Constants.VERSION;
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
		versionIcon = (ImageView)findViewById(R.id.versionflag);
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
                .setMessage("退出不删除任何历史数据，下次登陆仍然可以使用本账号（"+AppContext.getInstance(getBaseContext()).getUserAccount()+"）。")  
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {  
                    public void onClick(DialogInterface dialog, int which) {
                    	logout();
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
	
	@Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {  
        if (keyCode == KeyEvent.KEYCODE_BACK) {  
        	  Intent i = new Intent(Intent.ACTION_MAIN);
        	  i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        	  i.addCategory(Intent.CATEGORY_HOME);
        	  startActivity(i);
             
            return false;  
        } else {  
            return super.onKeyDown(keyCode, event);  
        }  
    }  
}
