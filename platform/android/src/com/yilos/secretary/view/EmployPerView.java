package com.yilos.secretary.view;

import java.util.List;

import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.EmployeePerBean;
import com.yilos.secretary.chartview.EmployeeChartView;
import com.yilos.secretary.common.StringUtils;

public class EmployPerView {

	    // 绘制员工业绩报表
		public void setEmployPerChartView(Context context,View v,List<EmployeePerBean> employPerList,LinearLayout columnarLayout) {
			String[] num = new String[employPerList.size()];
			String[] name = new String[employPerList.size()];
			float total = 0.0f;

			// 柱状图
			for (int i = 0; i < employPerList.size(); i++) {
				String totalnum = employPerList.get(i).getTotal();
				if (null == totalnum || "".equals(totalnum)) {
					totalnum = "0";
				}
				num[i] = totalnum + "|" + employPerList.get(i).getEmployee_name();
				;
				total += Float
						.valueOf(employPerList.get(i).getTotal() == null ? "0.0"
								: employPerList.get(i).getTotal());
			}
			String[] numSort = new String[employPerList.size()];
			numSort = StringUtils.bubbleSort(num);
			for (int i = 0; i < num.length; i++) {
				int index = numSort[i].indexOf("|");
				name[i] = numSort[i].substring(index + 1, numSort[i].length());
				num[i] = numSort[i].substring(0, index);
			}
			
			columnarLayout = (LinearLayout) v.findViewById(R.id.columnarLayout);
			columnarLayout.removeAllViews();
			EmployeeChartView view = new EmployeeChartView(context, num,
					name);
			columnarLayout.addView(view);

			total = (float) (Math.round(total * 10)) / 10;
			((TextView) v.findViewById(R.id.employeetotal)).setText("￥" + total);

		}
}
