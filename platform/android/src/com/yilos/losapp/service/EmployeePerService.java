package com.yilos.losapp.service;

import android.content.Context;

import com.yilos.losapp.database.EmployeePerDBManager;

public class EmployeePerService 
{
	private  EmployeePerDBManager employeePerDBManager;
	
	public EmployeePerService(Context context)
	{
		employeePerDBManager =new EmployeePerDBManager(context);
	}
}
