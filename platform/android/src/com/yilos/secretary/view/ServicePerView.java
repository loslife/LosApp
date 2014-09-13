package com.yilos.secretary.view;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.ServicePerformanceBean;
import com.yilos.secretary.chartview.ServiceGoodsChartView;
import com.yilos.secretary.common.StringUtils;

public class ServicePerView {
	
	    // 绘制卖品业绩报表
		public void setServicePerChartView(Context context,View v,List<ServicePerformanceBean> servicePerformanceList) {
			float total = 0.0f;
			List<String> cateNameList = new ArrayList<String>();
			List<Float> cateTotalList = new ArrayList<Float>();
			for (ServicePerformanceBean bean : servicePerformanceList) {
				// newcard":13000,"recharge":10,"service":1900,"product":200
				total += Float.valueOf(bean.getTotal());
				if (!cateNameList.contains(bean.getProject_cateName())) {
					cateNameList.add(bean.getProject_cateName());
				}
			}
			int length = cateNameList.size();

			float[] percentNum = new float[cateNameList.size()];
			String[] projectName = new String[cateNameList.size()];
			float otherPercentTotal = 0.0f;

			float[] otherPercentNum = null;
			String[] otherProjectName = null;
			String[] otherProjectTotal = null;
			if (length - 3 > 0) {
				otherPercentNum = new float[length - 3];
				otherProjectName = new String[length - 3];
				otherProjectTotal = new String[length - 3];
				((TextView) v.findViewById(R.id.othertext)).setText("其他");
			}

			for (int i = 0; i < length; i++) {

				for (ServicePerformanceBean bean : servicePerformanceList) {
					if (bean.getProject_cateName().equals(cateNameList.get(i))) {
						percentNum[i] += (float) (Math.round(Float.valueOf(bean
								.getTotal()) / total * 1000)) / 10;
						projectName[i] = percentNum[i] + "|" + cateNameList.get(i);
					}
				}
			}
			if (length > 0) {
				String[] numSort = new String[percentNum.length];
				numSort = StringUtils.bubbleSort(projectName);
				for (int i = 0; i < percentNum.length; i++) {
					int index = numSort[i].indexOf("|");
					percentNum[i] = Float.valueOf(numSort[i].substring(0, index));
					projectName[i] = numSort[i].substring(index + 1,
							numSort[i].length());

				}
				// qita
				for (int i = 0; i < percentNum.length; i++) {
					if (i > 2) {
						otherPercentNum[(i - 3)] = (float) (Math
								.round(percentNum[i] * 10)) / 10;
						otherProjectName[(i - 3)] = projectName[i];
						float otherTotal = 0.0f;
						for (ServicePerformanceBean bean : servicePerformanceList) {
							if (bean.getProject_cateName().equals(projectName[i])) {
								otherTotal += Float.valueOf(bean.getTotal());
							}
						}
						otherProjectTotal[(i - 3)] = String.valueOf(otherTotal);
						// 其他总数
						otherPercentTotal += otherPercentNum[(i - 3)];
						percentNum[3] = (float) (Math.round(otherPercentTotal * 10)) / 10;
						projectName[3] = "其他";
					}

				}
			}
			
			// 环形图
			LinearLayout annular2Layout = (LinearLayout) v.findViewById(R.id.annular2Layout);
			annular2Layout.removeAllViews();
			ServiceGoodsChartView panelDountView = new ServiceGoodsChartView(
					context, percentNum, projectName, "service");
			annular2Layout.addView(panelDountView);

			total = (float) (Math.round(total * 10)) / 10;
			((TextView) v.findViewById(R.id.servicetotal)).setText("￥" + total);
			setOtherListView(context,v,otherPercentNum, otherProjectName, otherProjectTotal);
			if (total == 0.0f) {
				((LinearLayout) v.findViewById(R.id.service_empty))
						.setVisibility(View.VISIBLE);
			} else {
				((LinearLayout) v.findViewById(R.id.service_empty))
						.setVisibility(View.GONE);
			}
		}
		
		private void setOtherListView(Context context,View v,float[] otherPercentNum,
				String[] otherProjectName, String[] otherProjectTotal) {
			// 绑定Layout里面的ListView
			ListView list = (ListView) v.findViewById(R.id.otherdata);
			if (null == otherPercentNum) {
				list.setAdapter(null);
			} else {
				// 生成动态数组，加入数据
				ArrayList<HashMap<String, Object>> listItem = new ArrayList<HashMap<String, Object>>();
				for (int i = 0; i < otherProjectName.length; i++) {
					String otherName = (i + 4) + "." + otherProjectName[i];
					String otherpercent = otherPercentNum[i] + "%";
					String otherTotal = "￥"
							+ (float) (Math.round(Float
									.valueOf(otherProjectTotal[i]) * 10)) / 10;
					if (otherName.length() > 12) {
						otherName = otherName.substring(0, 10) + "...";
					}
					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("othername", otherName);
					map.put("otherpercent", otherpercent);
					map.put("othertotal", otherTotal);
					listItem.add(map);
				}

				// 生成适配器的Item和动态数组对应的元素
				SimpleAdapter listItemAdapter = new SimpleAdapter(context, listItem,
						R.layout.otherdata_item,// ListItem的XML实现
						// 动态数组与ImageItem对应的子项
						new String[] { "othername", "otherpercent", "othertotal" },
						// ImageItem的XML文件里面的一个ImageView,两个TextView ID
						new int[] { R.id.othername, R.id.otherpercent,
								R.id.othertotal });
				// 添加并且显示
				list.setAdapter(listItemAdapter);
			}
		}
}
