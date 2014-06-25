package com.yilos.losapp;

import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.RadioButton;
import android.widget.TabHost;
import android.widget.TextView;

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
          
        this.mainIntent = new Intent(this,Main.class);  
        this.concactsIntent = new Intent(this,MemberGoupActivity.class);  
        this.settingCIntent = new Intent(this,SettingActivity.class);  
       
          
        ((RadioButton)findViewById(R.id.contacts)).setOnCheckedChangeListener(this);  
        ((RadioButton) findViewById(R.id.setting)).setOnCheckedChangeListener(this);  
        ((RadioButton) findViewById(R.id.operate)).setOnCheckedChangeListener(this);

        setupIntent();  
    }  
  
    @Override  
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {  
        if(isChecked){  
            switch (buttonView.getId()) {  
            case R.id.operate:  
                this.mTabHost.setCurrentTabByTag("OPERATE");  
                break;  
            case R.id.contacts:  
                this.mTabHost.setCurrentTabByTag("CONTACTS");  
                break;  
            case R.id.setting:  
                this.mTabHost.setCurrentTabByTag("SETTING");  
                break;  
            
            }  
        }  
          
    }  
      
    private void setupIntent() {  
        /*this.mTabHost = getTabHost();  
        TabHost localTabHost = this.mTabHost;  
  
        localTabHost.addTab(buildTabSpec("OPERATE", null,  
                null, this.mainIntent));  
  
        localTabHost.addTab(buildTabSpec("CONTACTS", null,  
                null, this.concactsIntent));  
  
        localTabHost.addTab(buildTabSpec("SETTING",  
                "", R.drawable.icon_3_n,  
                this.settingCIntent));  */

    }  
      
    private TabHost.TabSpec buildTabSpec(String tag, int resLabel, int resIcon,  
            final Intent content) {  
        return this.mTabHost.newTabSpec(tag).setIndicator(getString(resLabel),  
                getResources().getDrawable(resIcon)).setContent(content);  
    }  

}
