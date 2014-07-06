package com.yilos.losapp;

import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.service.MemberService;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MemberDetailActivity extends BaseActivity
{
	private TextView memberName;

    private TextView latestConsumeTime;
    
    private TextView birthday;
    
    private TextView totalConsume;
    
    private TextView memberNo;
    
    private TextView joinDate;
    
    private TextView phoneMobile;
    
    private TextView averageConsume;
    
    private MemberService memberService;
    
    private MemberBean memberInfo;

	 protected void onCreate(Bundle savedInstanceState) {
         super.onCreate(savedInstanceState);
         setContentView(R.layout.memberdetail);
         memberInfo = (MemberBean)getIntent().getSerializableExtra("memberInfo");
         initView();
         initData();
     }
	 
	 public void initView()
	 {
		 memberName = (TextView)findViewById(R.id.memberName);
		 latestConsumeTime = (TextView)findViewById(R.id.consumetimes);
		 birthday = (TextView)findViewById(R.id.birthday);
	     totalConsume = (TextView)findViewById(R.id.consumetotal);
	     memberNo = (TextView)findViewById(R.id.memberNo);
		 joinDate = (TextView)findViewById(R.id.joindate);
		 phoneMobile = (TextView)findViewById(R.id.memberPhone);
		 averageConsume =(TextView)findViewById(R.id.customerprice);
	 }
	 
	 public void initData()
	 {
		 memberName.setText(memberInfo.getName());

		 latestConsumeTime.setText(memberInfo.getLatestConsumeTime());
		 birthday.setText(memberInfo.getBirthday());
		 totalConsume.setText(memberInfo.getTotalConsume());
		 memberNo.setText(memberInfo.getMemberNo());
		 joinDate.setText(memberInfo.getJoinDate());
		 phoneMobile.setText(memberInfo.getPhoneMobile());
		 averageConsume.setText(memberInfo.getAverageConsume());
		 
	 }

	
}
