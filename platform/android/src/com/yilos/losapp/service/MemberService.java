package com.yilos.losapp.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.yilos.losapp.bean.MemberBean;
import com.yilos.losapp.bean.ContactsRecords;
import com.yilos.losapp.common.Pinyin_Comparator;
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
	
	public void handleMembers(ContactsRecords recotds)
	{
		//添加
		/*String[] members = new String[recotds.getAdd().size()];
		for (int i = 0; i < recotds.getAdd().size(); i++) {
			members[i] = recotds.getAdd().get(i).getName() + "|" + i;
		}
		Arrays.sort(members, new Pinyin_Comparator());
		List<MemberBean> parentData = new ArrayList<MemberBean>();
		for(String name:members)
		{
			int i = name.indexOf("|");
			String p = members[i].substring(i + 1,
					members[i].length());
		
			parentData.add(recotds.getAdd().get(Integer.valueOf(p)));
		}	*/
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
	
	public MemberBean queryMemberInfo(String id)
	{
		return memberDBManager.queryDetailById(id);
	}
	
	public List<MemberBean> seachRecords(String enterpriseId,String filter)
	{
		return memberDBManager.queryListByseach(enterpriseId,filter);
	}

}
