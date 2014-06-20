package com.yilos.losapp.service;

import java.util.List;

import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.bean.Records;
import com.yilos.losapp.database.MemberDBManager;

import android.content.Context;

/**
 * 
 * 会员数据的本地处理
 *
 */
public class MemberService {
	
	private MemberDBManager memberDBManager;
	
	public MemberService(Context context)
	{
		memberDBManager = new MemberDBManager(context);
	}
	
	public void handleMembers(Records recotds)
	{
		//添加
		addMembers(recotds.getAdd());
		
		//更新
		updateMembers(recotds.getUpdate());
		
		//删除
		delMembers(recotds.getRemove());
	}
	
	public void addMembers(List<MemberBean> members)
	{
		memberDBManager.add(members);
	}
	
	public void updateMembers(List<MemberBean> members)
	{
		  for (MemberBean person : members) 
		  {
			  memberDBManager.update(person);
		  }
	}
	
	public void delMembers(List<MemberBean> members)
	{
		  for (MemberBean person : members) 
		  {
			  memberDBManager.delete(person);
		  }
	}
	
	
	public List<MemberBean> queryMembers(String enterpriseId)
	{
		return memberDBManager.query(enterpriseId);
	}

}
