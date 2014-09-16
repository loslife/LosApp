package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.bean.IncomePerformanceBean;
import com.yilos.secretary.common.DateUtil;
import com.yilos.secretary.database.IncomePerDBManager;

public class IncomePerformanceService {


	private  IncomePerDBManager IncomePerDB;
	
	public IncomePerformanceService(Context context)
	{
		IncomePerDB =new IncomePerDBManager(context);
	}
	
	public void addIncomePerformance(IncomePerformanceBean incomePerformanceBean,String tableName)
	{
		IncomePerDB.add(incomePerformanceBean, tableName);
	}
	
	public void updateIncomePerformance(List<IncomePerformanceBean> incomePerformanceList,String tableName)
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
	
	// 获取本地服务业绩
		public IncomePerformanceBean getLocalIncomePerformanceData(String dateType,
				String year, String month, String day, int getFlag) {
			
			List<IncomePerformanceBean> incomePerformanceList = null;
			List<IncomePerformanceBean> prevIncomePerformanceList = null;
			IncomePerformanceBean incomePerformance = null;
			IncomePerformanceBean prevIncomePerformance = null;

			int prevMonth = Integer.valueOf(month) - 2;
			int pevYear = Integer.valueOf(year);
			if (prevMonth == -1) {
				prevMonth = 12;
				pevYear = Integer.valueOf(year) - 1;
			}
			// 获取本地数据
			if (dateType == "day") {
				incomePerformanceList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"income_performance_day");
				prevIncomePerformanceList = queryListBydate(pevYear + "", prevMonth + "",
						day, dateType, "income_performance_day");

			} else if (dateType == "month") {
				incomePerformanceList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"biz_performance_month");
				prevIncomePerformanceList = queryListBydate(pevYear + "", prevMonth + "",
						day, dateType, "income_performance_month");
			} else {
				incomePerformanceList = queryListBydate(year,
						(Integer.valueOf(month) - 1) + "", day, dateType,
						"income_performance_week");
				prevIncomePerformanceList = queryListBydate(pevYear + "", prevMonth + "",
						DateUtil.getPreviousSundayNum() + "", dateType,
						"income_performance_week");
			}

			if (incomePerformanceList.size() > 0) {
				incomePerformance = incomePerformanceList.get(0);
			} else {
				incomePerformance = new IncomePerformanceBean();
				incomePerformance.setTotal_income("0.0");
			}
			if (prevIncomePerformanceList.size() > 0) {
				prevIncomePerformance = prevIncomePerformanceList.get(0);
			} else {
				prevIncomePerformance = new IncomePerformanceBean();
				prevIncomePerformance.setTotal_income("0.0");
			}

			if (getFlag == 0) {
				return incomePerformance;
			} else {
				return prevIncomePerformance;
			}

		}

}
