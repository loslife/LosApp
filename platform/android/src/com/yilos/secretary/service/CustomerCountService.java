package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.bean.BcustomerCountBean;
import com.yilos.secretary.database.CustomerCountDBManager;

public class CustomerCountService 
{

	private  CustomerCountDBManager customerCountDBManager;
	
	public CustomerCountService(Context context)
	{
		customerCountDBManager =new CustomerCountDBManager(context);
	}
	
	public void addCustomerCount(List<BcustomerCountBean> customerCountList,String tableName)
	{
		customerCountDBManager.add(customerCountList, tableName);
	}
	
	public void updateCustomerCount(List<BcustomerCountBean> customerCountList,String tableName)
	{
		for(BcustomerCountBean bean:customerCountList)
		{
			customerCountDBManager.update(bean,tableName);
		}
	}
	
	public List<BcustomerCountBean> queryListBydate(String year, String month, String day, String type, String tableName)
	{
		return customerCountDBManager.queryListBydate(year, month, day, type, tableName);
	}
	
	public void deltel(String year, String month, String day, String type, String tableName)
	{
		customerCountDBManager.deleteBydate( year, month, day, type, tableName);
	}
	
	// 获取本地 客流量
		public List<BcustomerCountBean> getLocalBcustomerCount(String dateType,String year,String month,String day) {
			List<BcustomerCountBean>  countList;
			
			if (dateType == "day") {
				countList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"customer_count_day");
			} else if (dateType == "month") {
				countList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"customer_count_month");
			} else {
				countList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"customer_count_week");
			}

			return countList;

		}

}
