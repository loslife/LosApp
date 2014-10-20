package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.bean.ServicePerformanceBean;
import com.yilos.secretary.database.ServicePerformanceDBManager;

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
	
	// 获取本地 卖品业绩
		public List<ServicePerformanceBean> getLocalServicePerformanceData(String dateType,String year,String month,String day) {

			List<ServicePerformanceBean> serviceList;
			
			if ("day".equals(dateType)) {
				serviceList = queryListBydate(
						year, (Integer.valueOf(month) - 1) + "", day, dateType,
						"service_performance_day");
			} else if ("month".equals(dateType)) {
				serviceList = queryListBydate(
						year, (Integer.valueOf(month) - 1) + "", day, dateType,
						"service_performance_month");
			} else {
				serviceList = queryListBydate(
						year, (Integer.valueOf(month) - 1) + "", day, dateType,
						"service_performance_week");
			}
			
			return serviceList;
		}

}
