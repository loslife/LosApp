package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.bean.EmployeePerBean;
import com.yilos.secretary.database.EmployeePerDBManager;

public class EmployeePerService {
	private EmployeePerDBManager employeePerDBManager;


	public EmployeePerService(Context context) {
		employeePerDBManager = new EmployeePerDBManager(context);
	}

	public void addEmployeePer(List<EmployeePerBean> employeePerBean,
			String tableName) {
		employeePerDBManager.add(employeePerBean, tableName);
	}

	public void updateEmployeePer(List<EmployeePerBean> employeePerBean,
			String tableName) {
		for (EmployeePerBean bean : employeePerBean) {
			employeePerDBManager.update(bean, tableName);
		}
	}

	public List<EmployeePerBean> queryListBydate(String year, String month,
			String day, String type, String tableName) {
		return employeePerDBManager.queryListBydate(year, month, day, type,
				tableName);
	}

	public void deltel(String year, String month, String day, String type,
			String tableName) {
		employeePerDBManager.deleteBydate(year, month, day, type, tableName);
	}

	// 获取本地 员工业绩
	public List<EmployeePerBean> getLocalEmployeePerData(String dateType,
			String year, String month, String day) {

		List<EmployeePerBean> employPerList;

		// 获取本地数据
		if (dateType == "day") {
			employPerList = queryListBydate(year, (Integer.valueOf(month) - 1)
					+ "", day, dateType, "employee_performance_day");
		} else if (dateType == "month") {
			employPerList = queryListBydate(year, (Integer.valueOf(month) - 1)
					+ "", day, dateType, "employee_performance_month");
		} else {
			employPerList = queryListBydate(year, (Integer.valueOf(month) - 1)
					+ "", day, dateType, "employee_performance_week");
		}

		return employPerList;
	}
}
