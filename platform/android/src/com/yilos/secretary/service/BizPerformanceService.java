package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.database.BizPerformanceDBManager;

public class BizPerformanceService 
{

	private  BizPerformanceDBManager bizPerformanceDB;
	
	public BizPerformanceService(Context context)
	{
		bizPerformanceDB =new BizPerformanceDBManager(context);
	}
	
	public void addBizPerformance(BizPerformanceBean bizPerformanceBean,String tableName)
	{
		bizPerformanceDB.add(bizPerformanceBean, tableName);
	}
	
	public void updateBizPerformance(List<BizPerformanceBean> bizPerformanceBean,String tableName)
	{
		for(BizPerformanceBean bean:bizPerformanceBean)
		{
			bizPerformanceDB.update(bean,tableName);
		}
	}
	
	public List<BizPerformanceBean> queryListBydate(String year, String month, String day, String type, String tableName)
	{
		return bizPerformanceDB.queryListBydate(year, month, day, type, tableName);
	}
	
	public void deltel(String year, String month, String day, String type, String tableName)
	{
		bizPerformanceDB.deleteBydate( year, month, day, type, tableName);
	}

}
