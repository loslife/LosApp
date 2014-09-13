package com.yilos.secretary.view;

import java.util.List;

import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.BcustomerCountBean;
import com.yilos.secretary.chartview.TrafficChartView;
import com.yilos.secretary.common.DateUtil;

public class CustomerCountView 
{
	
	// 绘制客流量报表
	public void setCustomerCountChartView(Context context, View v,
			List<BcustomerCountBean> customerCountList, String year,
			String month, String day, String dateType) {
		DateUtil dateUtil = new DateUtil();
		String[] yNum = dateUtil.getDayarr(year, month, dateType);
		int walkinCount = 0;
		int memberCount = 0;
		int[] count = new int[yNum.length];
		for (int i = 0; i < yNum.length; i++) {
			count[i] = 0;
			for (BcustomerCountBean bean : customerCountList) {
				if (null != bean.get_id()) {
					if (i == bean.getHour() && "day".equals(dateType)) {
						walkinCount += Integer.valueOf(bean.getTemp());
						memberCount += Integer.valueOf(bean.getMember());
						int daytotal = Integer.valueOf(bean.getTemp())
								+ Integer.valueOf(bean.getMember());
						count[i] = daytotal;
						break;
					}

					else if ((i + 1) == Integer.valueOf(bean.getDay())
							&& "month".equals(dateType)) {
						walkinCount += Integer.valueOf(bean.getTemp());
						memberCount += Integer.valueOf(bean.getMember());
						int daytotal = Integer.valueOf(bean.getTemp())
								+ Integer.valueOf(bean.getMember());
						count[i] = daytotal;
						break;
					}

					else if ("week".equals(dateType)
							&& Integer.valueOf(yNum[i].substring(3,
									yNum[i].length())) == Integer.valueOf(bean
									.getDay())) {
						walkinCount += Integer.valueOf(bean.getTemp());
						memberCount += Integer.valueOf(bean.getMember());
						int daytotal = Integer.valueOf(bean.getTemp())
								+ Integer.valueOf(bean.getMember());
						count[i] = daytotal;
						break;
					}
				}
			}
		}
		((TextView) v.findViewById(R.id.personNum)).setText("会员" + memberCount
				+ "人次  散客" + walkinCount + "人次");

		// 折线图
		LinearLayout myView = (LinearLayout) v.findViewById(R.id.myView);
		myView.removeAllViews();
		TrafficChartView chartView = new TrafficChartView(context, yNum, // Y轴刻度
				new String[] { "0", "10", "20", "30", "40", "50" }, // X轴刻度
				count// 数据
		);
		myView.addView(chartView);
	}

}
