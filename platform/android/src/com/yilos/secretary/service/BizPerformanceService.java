package com.yilos.secretary.service;

import java.util.List;

import android.content.Context;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.common.DateUtil;
import com.yilos.secretary.database.BizPerformanceDBManager;

public class BizPerformanceService {

	private BizPerformanceDBManager bizPerformanceDB;

	public BizPerformanceService(Context context) {
		bizPerformanceDB = new BizPerformanceDBManager(context);
	}

	public void addBizPerformance(BizPerformanceBean bizPerformanceBean,
			String tableName) {
		bizPerformanceDB.add(bizPerformanceBean, tableName);
	}

	public void updateBizPerformance(
			List<BizPerformanceBean> bizPerformanceBean, String tableName) {
		for (BizPerformanceBean bean : bizPerformanceBean) {
			bizPerformanceDB.update(bean, tableName);
		}
	}

	public List<BizPerformanceBean> queryListBydate(String year, String month,
			String day, String type, String tableName) {
		return bizPerformanceDB.queryListBydate(year, month, day, type,
				tableName);
	}

	public void deltel(String year, String month, String day, String type,
			String tableName) {
		bizPerformanceDB.deleteBydate(year, month, day, type, tableName);
	}
	
	public int queryAll(String tableName)
	{
		return bizPerformanceDB.queryAll(tableName);
	}

	// 获取本地服务业绩
	public BizPerformanceBean getLocalBizPerformanceData(String dateType,
			String year, String month, String day, int getFlag) {
		
		List<BizPerformanceBean> bizPerformanceList = null;
		List<BizPerformanceBean> prevPerformanceList = null;
		BizPerformanceBean bizPerformance = null;
		BizPerformanceBean prevBizPerformance = null;

		int prevMonth = Integer.valueOf(month) - 2;
		int pevYear = Integer.valueOf(year);
		if (prevMonth == -1) {
			prevMonth = 12;
			pevYear = Integer.valueOf(year) - 1;
		}
		// 获取本地数据
		if (dateType == "day") {
			bizPerformanceList = queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_day");
			prevPerformanceList = queryListBydate(pevYear + "", prevMonth + "",
					day, dateType, "biz_performance_day");

		} else if (dateType == "month") {
			bizPerformanceList = queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_month");
			prevPerformanceList = queryListBydate(pevYear + "", prevMonth + "",
					day, dateType, "biz_performance_month");
		} else {
			bizPerformanceList = queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_week");
			prevPerformanceList = queryListBydate(pevYear + "", prevMonth + "",
					DateUtil.getPreviousSundayNum() + "", dateType,
					"biz_performance_week");
		}

		if (bizPerformanceList.size() > 0) {
			bizPerformance = bizPerformanceList.get(0);
		} else {
			bizPerformance = new BizPerformanceBean();
			bizPerformance.setTotal("0.0");
		}
		if (prevPerformanceList.size() > 0) {
			prevBizPerformance = prevPerformanceList.get(0);
		} else {
			prevBizPerformance = new BizPerformanceBean();
			prevBizPerformance.setTotal("0.0");
		}

		if (getFlag == 0) {
			return bizPerformance;
		} else {
			return prevBizPerformance;
		}

	}
}
