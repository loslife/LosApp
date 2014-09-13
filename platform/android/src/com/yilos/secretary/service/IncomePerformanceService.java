package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.bean.IncomePerformanceBean;
import com.yilos.secretary.database.IncomePerDBManager;

public class IncomePerformanceService {


	private  IncomePerDBManager IncomePerDB;
	
	public IncomePerformanceService(Context context)
	{
		IncomePerDB =new IncomePerDBManager(context);
	}
	
	public void addBizPerformance(IncomePerformanceBean incomePerformanceBean,String tableName)
	{
		IncomePerDB.add(incomePerformanceBean, tableName);
	}
	
	public void updateBizPerformance(List<IncomePerformanceBean> incomePerformanceList,String tableName)
	{
		for(IncomePerformanceBean bean:incomePerformanceList)
		{
			IncomePerDB.update(bean,tableName);
		}
	}
	
	public List<IncomePerformanceBean> queryListBydate(String year, String month, String day, String type, String tableName)
	{
		return IncomePerDB.queryListBydate(year, month, day, type, tableName);
	}
	
	public void deltel(String year, String month, String day, String type, String tableName)
	{
		IncomePerDB.deleteBydate( year, month, day, type, tableName);
	}

}
