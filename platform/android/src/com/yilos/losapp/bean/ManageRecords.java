package com.yilos.losapp.bean;

import java.util.ArrayList;
import java.util.List;

public class ManageRecords 
{
	private List<EmployeePerBean> day = new ArrayList<EmployeePerBean>();
	
	private List<EmployeePerBean> week = new ArrayList<EmployeePerBean>();
	
	private List<EmployeePerBean> month = new ArrayList<EmployeePerBean>();

	public List<EmployeePerBean> getDay() {
		return day;
	}

	public void setDay(List<EmployeePerBean> day) {
		this.day = day;
	}

	public List<EmployeePerBean> getWeek() {
		return week;
	}

	public void setWeek(List<EmployeePerBean> week) {
		this.week = week;
	}

	public List<EmployeePerBean> getMonth() {
		return month;
	}

	public void setMonth(List<EmployeePerBean> month) {
		this.month = month;
	}
	
	

}
