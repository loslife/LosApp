package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.bean.EmployeePerBean;
import com.yilos.secretary.database.EmployeePerDBManager;

public class EmployeePerService 
{
	private  EmployeePerDBManager employeePerDBManager;
	
	public EmployeePerService(Context context)
	{
		employeePerDBManager =new EmployeePerDBManager(context);
	}
	
	public void addEmployeePer(List<EmployeePerBean> employeePerBean,String tableName)
	{
		employeePerDBManager.add(employeePerBean, tableName);
	}
	
	public void updateEmployeePer(List<EmployeePerBean> employeePerBean,String tableName)
	{
		for(EmployeePerBean bean:employeePerBean)
		{
			employeePerDBManager.update(bean,tableName);
		}
	}
	
	public List<EmployeePerBean> queryListBydate(String year, String month, String day, String type, String tableName)
	{
		return employeePerDBManager.queryListBydate(year, month, day, type, tableName);
	}
	
	public void deltel(String year, String month, String day, String type, String tableName)
	{
		employeePerDBManager.deleteBydate( year, month, day, type, tableName);
	}
}
