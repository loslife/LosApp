package com.yilos.losapp;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.yilos.losapp.bean.BcustomerCountBean;
import com.yilos.losapp.bean.BizPerformanceBean;
import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerManageResponse;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.bean.ServicePerformanceBean;
import com.yilos.losapp.common.DateUtil;
import com.yilos.losapp.common.NetworkUtil;
import com.yilos.losapp.common.ScrollLayout;
import com.yilos.losapp.common.StringUtils;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.BizPerformanceService;
import com.yilos.losapp.service.CustomerCountService;
import com.yilos.losapp.service.EmployeePerService;
import com.yilos.losapp.service.MyshopManageService;
import com.yilos.losapp.service.ProductPerformanceService;

public class Main extends BaseActivity {

	private String shopId;

	private MyshopManageService myshopService;
	private EmployeePerService employeePerService;
	private ProductPerformanceService productPerformanceService;
	private BizPerformanceService bizPerformanceService;
	private CustomerCountService customerCountService;

	private List<ServicePerformanceBean> servicePerformanceList;
	private BizPerformanceBean bizPerformance;
	private BizPerformanceBean prevBizPerformance;
	private List<EmployeePerBean> employPerList;
	private List<BcustomerCountBean> customerCountList;
	
	private String userAccount;

	private ImageView select_shop;

	private TextView shopname;

	private TextView showTime;
	private ImageView lefttime;
	private ImageView righttime;
	private TextView timetype;

	private PopupWindow popupWindow;
	private LinearLayout layout;
	private ListView listView;
	private String title[] = null;
	private String shopIds[] = null;

	private String dateType = "day";

	public static final int WIDTH = 280;
	public static final int HEIGHT = 250;

	private PanelBar view;
	private LinearLayout columnarLayout;
	private LinearLayout annularLayout;
	private LinearLayout annular2Layout;
	private ChartView myView;

	private ScrollLayout mainScrollLayout;
	private LinearLayout noshop;

	public static long datetime;

	private String year;

	private String day;

	private String month;

	@SuppressWarnings("deprecation")
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initView();
		initData();
	}
	
	  public void onResume() {
             super.onResume();
             shopId = AppContext.getInstance(getBaseContext())
 					.getCurrentDisplayShopId();
             initData();
      }
	  
	  public void onPause()
	  {
		  super.onPause();
		  shopId = AppContext.getInstance(getBaseContext())
					.getCurrentDisplayShopId();
	  }

	Handler handle = new Handler() {
		public void handleMessage(Message msg) {

			if (msg.what == 1) {
				String[] num = new String[employPerList.size()];
				String[] name = new String[employPerList.size()];
				float total = 0.0f;

				// 柱状图
				for (int i = 0; i < employPerList.size(); i++) {
					String totalnum = employPerList.get(i).getTotal();
					if(null==totalnum||"".equals(totalnum))
					{
						totalnum = "0";
					}
					num[i] = totalnum+"|"+employPerList.get(i).getEmployee_name();;
					total += Float.valueOf(employPerList.get(i).getTotal());
				}
				String[] numSort = new String[employPerList.size()];
				numSort = StringUtils.bubbleSort(num);
				for(int i = 0; i < num.length; i++)
				{
					int index = numSort[i].indexOf("|");
					name[i] = numSort[i].substring(index+1, numSort[i].length());
					num[i] = numSort[i].substring(0, index);
				}
				
				LinearLayout columnarLayout = (LinearLayout) findViewById(R.id.columnarLayout);
				columnarLayout.removeAllViews();
				view = new PanelBar(getBaseContext(), num, name);
				columnarLayout.addView(view);

				total = (float) (Math.round(total * 10)) / 10;
				((TextView) findViewById(R.id.employeetotal)).setText("￥"
						+ total);
			}

			if (msg.what == 2) {

				float newcard = 0.0f;
				float recharge = 0.0f;
				float service = 0.0f;
				float product = 0.0f;
				float total = 0.0f;
				
				float comparePrevNewcard = 0.0f;
				float comparePrevRecharge = 0.0f;
				float comparePrevService = 0.0f;
				float comparePrevProduct = 0.0f;
				
				float prev_newcard = 0.0f;
				float prev_recharge = 0.0f;
				float prev_service = 0.0f;
				float prev_product = 0.0f;
				
				float percent_newcard = 0.0f;
				float percent_recharge = 0.0f;
				float percent_service = 0.0f;
				float percent_product = 0.0f;
				
				if (null != bizPerformance.get_id()) {
					// newcard":13000,"recharge":10,"service":1900,"product":200
					newcard = Float.valueOf(bizPerformance.getNewcard())
							/ Float.valueOf(bizPerformance.getTotal());
					recharge = Float.valueOf(bizPerformance.getRecharge())
							/ Float.valueOf(bizPerformance.getTotal());
					service = Float.valueOf(bizPerformance.getService())
							/ Float.valueOf(bizPerformance.getTotal());
					product = Float.valueOf(bizPerformance.getProduct())
							/ Float.valueOf(bizPerformance.getTotal());
					total = Float.valueOf(bizPerformance.getTotal());
					total = (float) (Math.round(total * 10)) / 10;
					if(null != prevBizPerformance.get_id())
					  {
						prev_newcard = Float.valueOf(prevBizPerformance.getNewcard());
						comparePrevNewcard= Float.valueOf(bizPerformance.getNewcard())-prev_newcard;
						prev_recharge = Float.valueOf(prevBizPerformance.getRecharge());
						comparePrevRecharge= Float.valueOf(bizPerformance.getRecharge())-prev_recharge;
						prev_service = Float.valueOf(prevBizPerformance.getService());
						comparePrevService= Float.valueOf(bizPerformance.getService())-prev_service;
						prev_product = Float.valueOf(prevBizPerformance.getProduct());
						comparePrevProduct = Float.valueOf(bizPerformance.getProduct())-prev_product;
						
						percent_newcard = (Math.round((comparePrevNewcard/prev_newcard) * 1000)) / 10;
						percent_recharge =(Math.round((comparePrevRecharge/prev_recharge) * 1000)) / 10;
						percent_service = (Math.round((comparePrevService/prev_service) * 1000)) / 10;
						percent_product = (Math.round((comparePrevProduct/prev_product) * 1000)) / 10;
					  }
					 else
					 {
						comparePrevNewcard= Float.valueOf(bizPerformance.getNewcard());
						comparePrevRecharge= Float.valueOf(bizPerformance.getRecharge());
						comparePrevService= Float.valueOf(bizPerformance.getService());
						comparePrevProduct = Float.valueOf(bizPerformance.getProduct());
						
						percent_newcard = 100.0f;
						percent_recharge =100.0f;
						percent_service = 100.0f;
						percent_product = 100.0f;
					}
				}
				
				String  sevicedata = bizPerformance.getService()==null?"0.0":bizPerformance.getService();
				String  saledata = bizPerformance.getProduct()==null?"0.0":bizPerformance.getProduct();
				String  carddata = bizPerformance.getNewcard()==null?"0.0":bizPerformance.getNewcard();
				String  rechargedata = bizPerformance.getRecharge()==null?"0.0":bizPerformance.getRecharge();
				((TextView) findViewById(R.id.biztotal)).setText("￥" + total);
				((TextView) findViewById(R.id.sevicedata)).setText("￥"+ sevicedata);
				((TextView) findViewById(R.id.saledata)).setText("￥"+ saledata);
				((TextView) findViewById(R.id.carddata)).setText("￥"+carddata);
				((TextView) findViewById(R.id.rechargedata)).setText("￥"+ rechargedata);
				
				((TextView) findViewById(R.id.sevicedata)).setTextColor(getResources().getColor(R.color.gray_text));
				((TextView) findViewById(R.id.saledata)).setTextColor(getResources().getColor(R.color.gray_text));
				((TextView) findViewById(R.id.carddata)).setTextColor(getResources().getColor(R.color.gray_text));
				((TextView) findViewById(R.id.rechargedata)).setTextColor(getResources().getColor(R.color.gray_text));
				
				((ImageView) findViewById(R.id.sevicesicon)).setImageResource(R.drawable.down);
				((ImageView) findViewById(R.id.saleicon)).setImageResource(R.drawable.down);
				((ImageView) findViewById(R.id.cardicon)).setImageResource(R.drawable.down);
				((ImageView) findViewById(R.id.rechargeicon)).setImageResource(R.drawable.down);
				
				
				((TextView) findViewById(R.id.toprev_sevicedata)).setText("比上" + timetype.getText().toString()+": "+comparePrevService+ " "+percent_service+"%");
				((TextView) findViewById(R.id.toprev_saledata)).setText("比上" + timetype.getText().toString()+": "+comparePrevProduct+" "+percent_product+"%");
				((TextView) findViewById(R.id.toprev_carddata)).setText("比上" + timetype.getText().toString()+": "+comparePrevNewcard+" "+percent_newcard+"%");
				((TextView) findViewById(R.id.toprev_rechargedata)).setText("比上" + timetype.getText().toString()+": "+comparePrevRecharge+" "+percent_recharge+"%");
				
				if(comparePrevService>0.0)
				{
					((ImageView) findViewById(R.id.sevicesicon)).setImageResource(R.drawable.up);
					((TextView) findViewById(R.id.sevicedata)).setTextColor(getResources().getColor(R.color.orange_bg));
					((TextView) findViewById(R.id.toprev_sevicedata)).setText("比上" + timetype.getText().toString()+": +"+comparePrevService+ " +"+percent_service+"%");
				}
				
				if(comparePrevProduct>0.0)
				{
					((ImageView) findViewById(R.id.saleicon)).setImageResource(R.drawable.up);
					((TextView) findViewById(R.id.saledata)).setTextColor(getResources().getColor(R.color.orange_bg));
					((TextView) findViewById(R.id.toprev_saledata)).setText("比上" + timetype.getText().toString()+": +"+comparePrevProduct+" +"+percent_product+"%");
				}
				
				if(comparePrevNewcard>0.0)
				{
					((ImageView) findViewById(R.id.cardicon)).setImageResource(R.drawable.up);
					((TextView) findViewById(R.id.carddata)).setTextColor(getResources().getColor(R.color.orange_bg));
					((TextView) findViewById(R.id.toprev_carddata)).setText("比上" + timetype.getText().toString()+": +"+comparePrevNewcard+" +"+percent_newcard+"%");
				}
				
				if(comparePrevRecharge>0.0)
				{
					((ImageView) findViewById(R.id.rechargeicon)).setImageResource(R.drawable.up);
					((TextView) findViewById(R.id.rechargedata)).setTextColor(getResources().getColor(R.color.orange_bg));
					((TextView) findViewById(R.id.toprev_rechargedata)).setText("比上" + timetype.getText().toString()+": +"+comparePrevRecharge+" +"+percent_recharge+"%");
				}
				
				
				
				newcard = (float) (Math.round(newcard * 1000)) / 10;
				recharge = (float) (Math.round(recharge * 1000)) / 10;
				service = (float) (Math.round(service * 1000)) / 10;
				product = (float) (Math.round(product * 1000)) / 10;

				String[] perName = { "开卡业绩", "充值业绩", "服务业绩", "卖品业绩" };
				// 环形图
				float[] num2 = new float[] { newcard, recharge, service,
						product };
				annularLayout = (LinearLayout) findViewById(R.id.annularLayout);
				annularLayout.removeAllViews();
				PanelDountChart panelDountView = new PanelDountChart(
						getBaseContext(), num2, perName,"business");
				annularLayout.addView(panelDountView);
			}

			if (msg.what == 3) {
				float total = 0.0f;
				int length = servicePerformanceList.size();
				float[] percentNum = new float[4];
				String[] projectName = new String[4];
				float otherPercentTotal = 0.0f;
				
				float[] otherPercentNum =null;
				String[] otherProjectName =null;
				String[] otherProjectTotal =null;
				if(length-3>0)
				{
					otherPercentNum = new float[length-3];
					otherProjectName = new String[length-3];
					otherProjectTotal = new String[length-3];
					((TextView) findViewById(R.id.othertext)).setText("其他");
				}
				
				
				for (ServicePerformanceBean bean : servicePerformanceList) {
					// newcard":13000,"recharge":10,"service":1900,"product":200
					total += Float.valueOf(bean.getTotal());
				}

				for (int i = 0; i < length; i++) {
					if(i<3)
					{
						float percent = Float.valueOf(servicePerformanceList.get(i)
								.getTotal()) / total;
						percentNum[i] = (float) (Math.round(percent * 1000)) / 10;
						projectName[i] = servicePerformanceList.get(i)
								.getProject_name();
					}
					else
					{
						
						float percent = Float.valueOf(servicePerformanceList.get(i)
								.getTotal()) / total;
						otherPercentNum[(i-3)] = (float) (Math.round(percent * 1000)) / 10;
						otherProjectName[(i-3)] = servicePerformanceList.get(i)
								.getProject_name();
						otherProjectTotal [(i-3)] = servicePerformanceList.get(i)
								.getTotal();
						//其他总数
						otherPercentTotal += otherPercentNum[(i-3)];
						percentNum[3] = (float) (Math.round(otherPercentTotal * 1000)) / 10;
						projectName[3] = "其他";
					}
					
				}

				// 环形图
				annular2Layout = (LinearLayout) findViewById(R.id.annular2Layout);
				annular2Layout.removeAllViews();
				PanelDountChart panelDountView = new PanelDountChart(
						getBaseContext(), percentNum, projectName,"service");
				annular2Layout.addView(panelDountView);

				total = (float) (Math.round(total * 10)) / 10;
				((TextView) findViewById(R.id.servicetotal)).setText("￥"
						+ total);
				setOtherListView(otherPercentNum,otherProjectName,otherProjectTotal);	
				
			}

			if (msg.what == 4) {
				DateUtil dateUtil = new DateUtil();
				String[] yNum = dateUtil.getDayarr(year, month, dateType);

				int walkinCount = 0;
				int memberCount = 0;
				int[] count = new int[yNum.length];
				for (int i = 0; i < yNum.length; i++) {
					count[i] = 0;
					for (BcustomerCountBean bean : customerCountList) {
						if (null != bean.get_id()) {
							if(i == bean.getHour()&&"day".equals(dateType))
							{
								walkinCount += Integer.valueOf(bean.getTemp());
								memberCount += Integer.valueOf(bean.getMember());
								int daytotal = Integer.valueOf(bean.getTemp())
										+ Integer.valueOf(bean.getMember());
								count[i] = daytotal;
								break;
							}
							
							else if(i == Integer.valueOf(bean.getDay())&&"month".equals(dateType))
							{
								walkinCount += Integer.valueOf(bean.getTemp());
								memberCount += Integer.valueOf(bean.getMember());
								int daytotal = Integer.valueOf(bean.getTemp())
										+ Integer.valueOf(bean.getMember());
								count[i] = daytotal;
								break;
							}
							
							else if("week".equals(dateType)&&Integer.valueOf(yNum[i].substring(3, yNum[i].length())) == Integer.valueOf(bean.getDay()))
							{
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
				((TextView) findViewById(R.id.personNum)).setText("会员"
						+ memberCount + "人次  散客" + walkinCount + "人次");
				
				// 折线图
				myView = (ChartView) findViewById(R.id.myView);
				myView.SetInfo(yNum, // Y轴刻度
						new String[] { "0", "10", "20", "30", "40", "50" }, // X轴刻度
						count// 数据
				);
			}
		}
	};
	
	private void setOtherListView(float[] otherPercentNum,String[] otherProjectName,String[] otherProjectTotal)
	{
		//绑定Layout里面的ListView  
        ListView list = (ListView) findViewById(R.id.otherdata);  
        if(null==otherPercentNum)
        {
        	list.setAdapter(null); 
        }
        else
        {
	        //生成动态数组，加入数据  
	        ArrayList<HashMap<String, Object>> listItem = new ArrayList<HashMap<String, Object>>();  
	        for(int i=0;i<otherProjectName.length;i++)  
	        {  
	        	String otherName = (i+4)+"."+otherProjectName[i];
	        	String otherpercent = otherPercentNum[i]+"%";
	        	String otherTotal = "￥"+otherProjectTotal[i];
	        	if(otherName.length()>12)
	        	{
	        		otherName = otherName.substring(0, 10)+"...";
	        	}
	            HashMap<String, Object> map = new HashMap<String, Object>();  
	            map.put("othername", otherName);  
	            map.put("otherpercent", otherpercent); 
	            map.put("othertotal", otherTotal);
	            listItem.add(map);  
	        } 
	        
	        //生成适配器的Item和动态数组对应的元素  
	        SimpleAdapter listItemAdapter = new SimpleAdapter(this,listItem,//数据源   
	            R.layout.otherdata_item,//ListItem的XML实现  
	            //动态数组与ImageItem对应的子项          
	            new String[] {"othername","otherpercent","othertotal"},   
	            //ImageItem的XML文件里面的一个ImageView,两个TextView ID  
	            new int[] {R.id.othername,R.id.otherpercent,R.id.othertotal}  
	        );  
	        //添加并且显示  
	        list.setAdapter(listItemAdapter); 
        }
	}

	public void initView() {
		
		select_shop = (ImageView) findViewById(R.id.headmore);
		shopname = (TextView) findViewById(R.id.shopname);
		showTime = (TextView) findViewById(R.id.showtime);
		lefttime = (ImageView) findViewById(R.id.lefttime);
		righttime = (ImageView) findViewById(R.id.righttime);
		timetype = (TextView) findViewById(R.id.timetype);

		mainScrollLayout = (ScrollLayout) findViewById(R.id.main_scrolllayout);
		noshop = (LinearLayout) findViewById(R.id.noshop);

		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		showTime.setText(getDateNow());

		findViewById(R.id.goback).setVisibility(View.GONE);

		select_shop.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				select_shop.getRight();
				int y = select_shop.getBottom() * 2;
				int x = getWindowManager().getDefaultDisplay().getWidth() / 2;

				showPopupWindow(x, y);
			}
		});

		timetype.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if ("日".equals(timetype.getText().toString())) {
					dateType = "week";
					timetype.setText("周");
					DateUtil dateUtil = new DateUtil();
					String weeks = dateUtil.getCurrentMonday() + "--"
							+ dateUtil.getSunday();
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");
					datetime = dateToCal(dateUtil.getCurDateSunday(), formatter)
							.getTimeInMillis();
					Date weekdate = new Date(datetime);
					day = String.valueOf(weekdate.getDate());
					showTime.setText(weeks);

				} else if ("周".equals(timetype.getText().toString())) {
					dateType = "month";
					timetype.setText("月");
					showTime.setText(getDateNow().substring(0, 8));
				} else {
					dateType = "day";
					timetype.setText("日");
					showTime.setText(getDateNow());
				}
				getShowData();
			}

		});

		lefttime.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				String showtime = "";
				Date curDate;
				if (dateType == "month") {
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月");
					Calendar c = dateToCal(showTime.getText().toString(),
							formatter);
					c.add(c.MONTH, -1);// 得到上个月的月份

					curDate = new Date(c.getTimeInMillis());// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				} else if (dateType == "week") {
					DateUtil dateUtil = new DateUtil();
					showtime = dateUtil.getPreviousMonday() + "--"
							+ dateUtil.getSunday();
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");

					datetime = dateToCal(dateUtil.getCurDateSunday(), formatter)
							.getTimeInMillis();
					curDate = new Date(datetime);
					showTime.setText(showtime);
				} else {
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");
					curDate = new Date(dateToCal(showTime.getText().toString(),
							formatter).getTimeInMillis() - 86400000);// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				}

				year = String.valueOf(curDate.getYear() + 1900);
				day = String.valueOf(curDate.getDate());
				month = String.valueOf(curDate.getMonth()+1);
				getShowData();
			}
		});

		righttime.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String showtime = "";
				Date curDate;
				if (dateType == "month") {
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月");
					Calendar c = dateToCal(showTime.getText().toString(),
							formatter);
					c.add(c.MONTH, +1);// 得到下个月的月份
					curDate = new Date(c.getTimeInMillis());// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				} else if (dateType == "week") {
					DateUtil dateUtil = new DateUtil();
					showtime = dateUtil.getNextMonday() + "--"
							+ dateUtil.getSunday();
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");
					datetime = dateToCal(dateUtil.getCurDateSunday(), formatter)
							.getTimeInMillis();
					curDate = new Date(datetime);
					showTime.setText(showtime);
				} else {
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");
					curDate = new Date(dateToCal(showTime.getText().toString(),
							formatter).getTimeInMillis() + 86400000);// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				}
				// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
				year = String.valueOf(curDate.getYear() + 1900);
				day = String.valueOf(curDate.getDate());
				month = String.valueOf(curDate.getMonth()+1);
				getShowData();
			}
		});

	}

	/**
	 * 获得数据
	 */
	private void getShowData() {
			getEmployeePerData();
			getBizPerformanceData();
			getServicePerformanceData();
			getBcustomerCount();
	}

	/**
	 * 员工业绩
	 */
	public void getEmployeePerData() {
		if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
		{
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
	
					ServerManageResponse res = ac.getReportsData(shopId, year,
							month, dateType, day, "employee");
					if (res.isSucess()) {
	
						String tableName = "employee_performance_day";
						if (dateType == "day") {
							employPerList = res.getResult().getCurrent()
									.getTb_emp_performance().getDay();
							tableName = "employee_performance_day";
						} else if (dateType == "month") {
							employPerList = res.getResult().getCurrent()
									.getTb_emp_performance().getMonth();
							tableName = "employee_performance_month";
						} else {
							employPerList = res.getResult().getCurrent()
									.getTb_emp_performance().getWeek();
							tableName = "employee_performance_week";
						}
						// employeePerService.deltel(year, month, day, dateType,
						// tableName);
						employeePerService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day, dateType,
								tableName);
	
						employeePerService.addEmployeePer(employPerList, tableName);
						msg.what = 1;
						handle.sendMessage(msg);
					}
				}
			}.start();
		}
		else
		{
			shopId = AppContext.getInstance(getBaseContext())
 					.getCurrentDisplayShopId();
			//获取本地数据
			if (dateType == "day") {
				employPerList = employeePerService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "employee_performance_day");
			} else if (dateType == "month") {
				employPerList = employeePerService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "employee_performance_month");
			} else {
				employPerList = employeePerService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "employee_performance_week");
			}
			Message msg = new Message();
			msg.what = 1;
			handle.sendMessage(msg);
		}
	}

	/**
	 * 服务业绩
	 */
	public void getBizPerformanceData() {
		if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
		{
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
					// ServerManageResponse res = ac.getReportsData(shopId, year,
					// month, dateType, day,"employee");
	
					ServerManageResponse res = ac.getReportsData(shopId, year,
							month, dateType, day, "business");
					if (res.isSucess()) {
	
						String tableName = "biz_performance_day";
						if (dateType == "day") {
							bizPerformance = res.getResult().getCurrent()
									.getTb_biz_performance().getDay();
							prevBizPerformance = res.getResult().getPrev()
									.getTb_biz_performance().getDay();
							tableName = "biz_performance_day";
						} else if (dateType == "month") {
							bizPerformance = res.getResult().getCurrent()
									.getTb_biz_performance().getMonth();
							prevBizPerformance = res.getResult().getPrev()
									.getTb_biz_performance().getMonth();
							tableName = "biz_performance_month";
						} else {
							bizPerformance = res.getResult().getCurrent()
									.getTb_biz_performance().getWeek();
							prevBizPerformance = res.getResult().getPrev()
									.getTb_biz_performance().getWeek();
							tableName = "biz_performance_week";
						}
						// employeePerService.deltel(year, month, day, dateType,
						// tableName);
						int delprevMonth = Integer.valueOf(month) - 2;
						int delpevYear = Integer.valueOf(year);
						if(delprevMonth==-1)
						{
							delprevMonth = 12;
							delpevYear = Integer.valueOf(year) - 1;
						}
						
						bizPerformanceService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day, dateType,
								tableName);
						bizPerformanceService.deltel(delpevYear+"",
								delprevMonth + "", day, dateType,
								tableName);
						bizPerformanceService.addBizPerformance(bizPerformance,
								tableName);
						bizPerformanceService.addBizPerformance(prevBizPerformance,
								tableName);
						msg.what = 2;
						handle.sendMessage(msg);
					}
				}
			}.start();
		}
		else
		{
			shopId = AppContext.getInstance(getBaseContext())
 					.getCurrentDisplayShopId();
			List<BizPerformanceBean> bizPerformanceList = null;
			List<BizPerformanceBean> prevPerformanceList = null;
			
			int prevMonth = Integer.valueOf(month) - 2;
			int pevYear = Integer.valueOf(year);
			if(prevMonth==-1)
			{
				prevMonth = 12;
			    pevYear = Integer.valueOf(year) - 1;
			}
			//获取本地数据
			if (dateType == "day") {
				bizPerformanceList = bizPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "biz_performance_day");
				prevPerformanceList = bizPerformanceService.queryListBydate(pevYear+"", prevMonth+"", day, dateType, "biz_performance_day");
				
			} else if (dateType == "month") {
				bizPerformanceList = bizPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "biz_performance_month");
				prevPerformanceList = bizPerformanceService.queryListBydate(pevYear+"", prevMonth+"", day, dateType, "biz_performance_month");
			} else {
				bizPerformanceList = bizPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "biz_performance_week");
				prevPerformanceList = bizPerformanceService.queryListBydate(pevYear+"", prevMonth+"", DateUtil.getPreviousSundayNum()+"", dateType, "biz_performance_week");
			}
			
			if(bizPerformanceList.size()>0)
			{
				bizPerformance = bizPerformanceList.get(0);
			}
			if(prevPerformanceList.size()>0)
			{
				prevBizPerformance = prevPerformanceList.get(0);
			}
			
			Message msg = new Message();
			msg.what = 2;
			handle.sendMessage(msg);
		}
	}

	/**
	 * 产品业绩
	 */
	public void getServicePerformanceData() {
		if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
		{
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
					// ServerManageResponse res = ac.getReportsData(shopId, year,
					// month, dateType, day,"employee");
					ServerManageResponse res = ac.getReportsData(shopId, year,
							month, dateType, day, "service");
					if (res.isSucess()) {
	
						String tableName = "service_performance_day";
						if (dateType == "day") {
							servicePerformanceList = res.getResult().getCurrent()
									.getTb_service_performance().getDay();
							tableName = "service_performance_day";
						} else if (dateType == "month") {
							servicePerformanceList = res.getResult().getCurrent()
									.getTb_service_performance().getMonth();
							tableName = "service_performance_month";
						} else {
							servicePerformanceList = res.getResult().getCurrent()
									.getTb_service_performance().getWeek();
							tableName = "service_performance_week";
						}
						// employeePerService.deltel(year, month, day, dateType,
						// tableName);
						productPerformanceService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day, dateType,
								tableName);
						productPerformanceService.addProductPerformance(
								servicePerformanceList, tableName);
						msg.what = 3;
						handle.sendMessage(msg);
					}
				}
			}.start();
		}
		else
		{
			shopId = AppContext.getInstance(getBaseContext())
 					.getCurrentDisplayShopId();
			if (dateType == "day") {
				servicePerformanceList = productPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "service_performance_day");
			} else if (dateType == "month") {
				servicePerformanceList =  productPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "service_performance_month");
			} else {
				servicePerformanceList =  productPerformanceService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "service_performance_week");
			}
			
			Message msg = new Message();
			msg.what = 3;
			handle.sendMessage(msg);
		}
	}

	/**
	 * 客流量
	 */
	public void getBcustomerCount() {
		if(NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE)
		{
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					ServerManageResponse res = ac.getReportsData(shopId, year,
							month, dateType, day, "customer");
					if (res.isSucess()) {
						String tableName = "customer_count_day";
						if (dateType == "day") {
							customerCountList = res.getResult().getCurrent()
									.getB_customer_count().getHours();
							tableName = "customer_count_day";
						} else if (dateType == "week") {
							customerCountList = res.getResult().getCurrent()
									.getB_customer_count().getDays();
	
							tableName = "customer_count_week";
						} else {
							customerCountList = res.getResult().getCurrent()
									.getB_customer_count().getDays();
							tableName = "customer_count_month";
						}
						// employeePerService.deltel(year, month, day, dateType,
						// tableName);
						customerCountService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day, dateType,
								tableName);
						customerCountService.addCustomerCount(customerCountList,
								tableName);
						msg.what = 4;
						handle.sendMessage(msg);
					}
	
				}
			}.start();
		}
		else
		{
			shopId = AppContext.getInstance(getBaseContext())
 					.getCurrentDisplayShopId();
			if (dateType == "day") 
			{
				customerCountList = customerCountService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "customer_count_day");
			} 
			else if (dateType == "month")
			{
				customerCountList = customerCountService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "customer_count_month");
			}
			else
			{
				customerCountList = customerCountService.queryListBydate(year, (Integer.valueOf(month) - 1) + "", day, dateType, "customer_count_week");
			}
			
			Message msg = new Message();
			msg.what = 4;
			handle.sendMessage(msg);
		}
	}

	public void initData() {

		myshopService = new MyshopManageService(getBaseContext());
		employeePerService = new EmployeePerService(getBaseContext());
		productPerformanceService = new ProductPerformanceService(
				getBaseContext());
		bizPerformanceService = new BizPerformanceService(getBaseContext());
		customerCountService = new CustomerCountService(getBaseContext());

		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			mainScrollLayout.setVisibility(View.VISIBLE);
			noshop.setVisibility(View.GONE);
			shopId = myshops.get(0).getEnterprise_id();
			title = new String[myshops.size()];
			shopIds = new String[myshops.size()];
			for (int i = 0; i < myshops.size(); i++) {
				title[i] = myshops.get(i).getEnterprise_name()==null?"":myshops.get(i).getEnterprise_name();
				shopIds[i] = myshops.get(i).getEnterprise_id();
			}
		} else {
			mainScrollLayout.setVisibility(View.GONE);
			noshop.setVisibility(View.VISIBLE);
		}
		if (title == null || !(title.length > 0)) {
			select_shop.setVisibility(View.GONE);
		}
		getShowData();
	}

	public void showPopupWindow(int x, int y) {
		layout = (LinearLayout) LayoutInflater.from(Main.this).inflate(
				R.layout.dialog, null);
		listView = (ListView) layout.findViewById(R.id.lv_dialog);
		listView.setAdapter(new ArrayAdapter<String>(Main.this, R.layout.text,
				R.id.tv_text, title));

		popupWindow = new PopupWindow(Main.this);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow
				.setWidth(getWindowManager().getDefaultDisplay().getWidth() / 2);
		popupWindow.setHeight(300);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		// showAsDropDown会把里面的view作为参照物，满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.LEFT
				| Gravity.TOP, x, y);// 需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				shopname.setText(title[arg2]);
				AppContext.getInstance(getBaseContext()).setShopName(title[arg2]);
				AppContext.getInstance(getBaseContext())
						.setCurrentDisplayShopId(shopIds[arg2]);
				shopId = shopIds[arg2];
				getShowData();
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

	public String getDateNow() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		Date curDate = new Date(System.currentTimeMillis());// 获取当前时间
		year = String.valueOf(curDate.getYear() + 1900);
		day = String.valueOf(curDate.getDate());
		month = String.valueOf(curDate.getMonth()+1);
		String str = formatter.format(curDate);
		return str;
	}

	public Calendar dateToCal(String in, SimpleDateFormat format) {

		Date date;
		Calendar cal = Calendar.getInstance();
		try {
			date = format.parse(in);
			cal.setTime(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return cal;
	}

}
