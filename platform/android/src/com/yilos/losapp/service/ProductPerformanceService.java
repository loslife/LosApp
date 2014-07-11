package com.yilos.losapp.service;

import java.util.List;

import android.content.Context;

import com.yilos.losapp.bean.ServicePerformanceBean;
import com.yilos.losapp.database.ServicePerformanceDBManager;

public class ProductPerformanceService 
{

	private  ServicePerformanceDBManager servicePerformanceDB;
	
	public ProductPerformanceService(Context context)
	{
		servicePerformanceDB =new ServicePerformanceDBManager(context);
	}
	
	public void addProductPerformance(List<ServicePerformanceBean> servicePerformanceList,String tableName)
	{
		servicePerformanceDB.add(servicePerformanceList, tableName);
	}
	
	public void updateProductPerformance(List<ServicePerformanceBean> servicePerformanceList,String tableName)
	{
		for(ServicePerformanceBean bean:servicePerformanceList)
		{
			servicePerformanceDB.update(bean,tableName);
		}
	}
	
	public List<ServicePerformanceBean> queryListBydate(String year, String month, String day, String type, String tableName)
	{
		return servicePerformanceDB.queryListBydate(year, month, day, type, tableName);
	}
	
	public void deltel(String year, String month, String day, String type, String tableName)
	{
		servicePerformanceDB.deleteBydate( year, month, day, type, tableName);
	}

}
