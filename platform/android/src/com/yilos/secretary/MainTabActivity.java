package com.yilos.secretary;


import android.annotation.SuppressLint;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.RadioButton;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;

import com.yilos.secretary.common.ActivityControlUtil;

public class MainTabActivity extends TabActivity implements OnCheckedChangeListener
{
	private TabHost mTabHost;  
    private Intent mainIntent;  
    private Intent concactsIntent;  
    private Intent settingCIntent;  

      
    /** Called when the activity is first created. */  
    @Override  
    public void onCreate(Bundle savedInstanceState) {  
        super.onCreate(savedInstanceState);  
        requestWindowFeature(Window.FEATURE_NO_TITLE);  
        setContentView(R.layout.main_footer);  
        ActivityControlUtil.add(this);
          
        this.mainIntent = new Intent(this,Main.class);
        this.concactsIntent = new Intent(this,MemberGoupActivity.class); 
        this.settingCIntent = new Intent(this,SettingActivity.class);

        ((RadioButton)findViewById(R.id.contacts)).setOnCheckedChangeListener(this);  
        ((RadioButton) findViewById(R.id.setting)).setOnCheckedChangeListener(this);  
        ((RadioButton) findViewById(R.id.operate)).setOnCheckedChangeListener(this);

        setupIntent();  
    }  
  
    @SuppressLint("ResourceAsColor")
	@Override  
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {  
    	Animation animation = null;
    	animation = new TranslateAnimation(0, 0, 0, 0);
        if(isChecked){  
            switch (buttonView.getId()) {  
            case R.id.operate: 
            	
            	((View)findViewById(R.id.oneline)).setBackgroundResource(R.color.blue_bg);
            	((View)findViewById(R.id.twoline)).setBackgroundResource(R.color.lightgray);
            	((View)findViewById(R.id.threeline)).setBackgroundResource(R.color.lightgray);
                this.mTabHost.setCurrentTabByTag("OPERATE"); 
                break;  
            case R.id.contacts:  
            
            	((View)findViewById(R.id.twoline)).setBackgroundResource(R.color.blue_bg);
            	((View)findViewById(R.id.threeline)).setBackgroundResource(R.color.lightgray);
            	((View)findViewById(R.id.oneline)).setBackgroundResource(R.color.lightgray);
                this.mTabHost.setCurrentTabByTag("CONTACTS");  
                break;  
            case R.id.setting:  
           
            	((View)findViewById(R.id.threeline)).setBackgroundResource(R.color.blue_bg);
            	((View)findViewById(R.id.oneline)).setBackgroundResource(R.color.lightgray);
            	((View)findViewById(R.id.twoline)).setBackgroundResource(R.color.lightgray);
                this.mTabHost.setCurrentTabByTag("SETTING");  
                break;  
            
            }  
        }  
          
    }  
      
    private void setupIntent() {  
        this.mTabHost = getTabHost();  
        TabHost localTabHost = this.mTabHost;
        
        // 将View添加到Tab布局中
        TabSpec spec1 = mTabHost.newTabSpec("OPERATE").setIndicator(null,getResources().getDrawable(R.color.orange)).setContent(mainIntent);
        mTabHost.addTab(spec1);
        
        // 将View添加到Tab布局中
        TabSpec spec2 = mTabHost.newTabSpec("CONTACTS").setIndicator(null,getResources().getDrawable(R.color.orange)).setContent(concactsIntent);
        mTabHost.addTab(spec2);
        
        // 将View添加到Tab布局中
        TabSpec spec3 = mTabHost.newTabSpec("SETTING").setIndicator(null,getResources().getDrawable(R.color.orange)).setContent(settingCIntent);
        mTabHost.addTab(spec3);
    }  
      
}
