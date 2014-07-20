package com.yilos.losapp;

import java.math.BigDecimal;

import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.common.DateUtil;
import com.yilos.losapp.service.MemberService;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
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
    
    private TextView cardtype;
    
    private ImageView headmore;
	
	private TextView  shopname;
	
	private RelativeLayout teltomember;
	
	private RelativeLayout msgtomember;
    
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
		 cardtype = (TextView)findViewById(R.id.cardtype);
		 shopname = (TextView)findViewById(R.id.shopname);
		 headmore = (ImageView)findViewById(R.id.headmore);
		 headmore.setVisibility(View.GONE);
		 shopname.setText("会员详情");
		 
		 teltomember = (RelativeLayout)findViewById(R.id.teltomember);
		 msgtomember = (RelativeLayout)findViewById(R.id.msgtomember);
		 
		 findViewById(R.id.goback).setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					finish();
				}
			});
		 
		 teltomember.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				    Intent intent = new Intent();
				    intent.setAction(Intent.ACTION_CALL);
				    intent.setData(Uri.parse("tel:"+ memberInfo.getPhoneMobile()));
				    startActivity(intent);				
			}
		});
		 
		 msgtomember.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					Uri smsToUri = Uri.parse("smsto:"+memberInfo.getPhoneMobile()); 
					Intent intent = new Intent(Intent.ACTION_SENDTO, smsToUri); 
					startActivity(intent); 			
				}
			});
	 }
	 
	 public void initData()
	 {
		 memberName.setText(memberInfo.getName());
		 cardtype.setText(memberInfo.getCardStr());
		 latestConsumeTime.setText(memberInfo.getLatestConsumeTime());
		 if(null!=memberInfo.getLatestConsumeTime()&&!"".equals(memberInfo.getLatestConsumeTime()))
		 {
			 BigDecimal latestConsumeTimetr = new BigDecimal(memberInfo.getLatestConsumeTime()); 
			 latestConsumeTime.setText(DateUtil.dateToString(latestConsumeTimetr.toPlainString(),"yyyy年MM月dd日"));
		 }
		 
		 birthday.setText(memberInfo.getBirthday());
		 if(null!=memberInfo.getBirthday()&&!"".equals(memberInfo.getBirthday()))
		 {
			 BigDecimal birthdaystr = new BigDecimal(memberInfo.getBirthday()); 
			 birthday.setText(DateUtil.dateToString(birthdaystr.toPlainString(),"MM月dd日"));
		 }
		
		 
		 totalConsume.setText("￥"+Float.valueOf(memberInfo.getTotalConsume()));
		 memberNo.setText(memberInfo.getMemberNo());
		 joinDate.setText(memberInfo.getJoinDate());
		 if(null!=memberInfo.getJoinDate()&&!"".equals(memberInfo.getJoinDate()))
		 {
			 BigDecimal joinDatestr = new BigDecimal(memberInfo.getJoinDate()); 
			 joinDate.setText(DateUtil.dateToString(joinDatestr.toPlainString(),"yyyy年MM月dd日"));
		 }
		 phoneMobile.setText(memberInfo.getPhoneMobile());
		 averageConsume.setText("￥"+Float.valueOf(memberInfo.getAverageConsume()));
		 
	 }

	
}
