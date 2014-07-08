package com.yilos.losapp.service;

import java.util.List;

import android.content.Context;

import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.database.EmployeePerDBManager;

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
}
