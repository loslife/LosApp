package com.yilos.losapp;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.yilos.losapp.bean.BcustomerCountBean;
import com.yilos.losapp.bean.BizPerformanceBean;
import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerManageResponse;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.bean.ServicePerformanceBean;
import com.yilos.losapp.common.DateUtil;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.BizPerformanceService;
import com.yilos.losapp.service.CustomerCountService;
import com.yilos.losapp.service.EmployeePerService;
import com.yilos.losapp.service.MyshopManageService;
import com.yilos.losapp.service.ProductPerformanceService;

public class Main extends BaseActivity {

	private TextView operate;

	private TextView contacts;

	private TextView setting;

	private String shopId;

	private MyshopManageService myshopService;
	private EmployeePerService employeePerService;
	private ProductPerformanceService productPerformanceService;
	private BizPerformanceService bizPerformanceService;
	private CustomerCountService customerCountService;
	
	private List<ServicePerformanceBean> servicePerformanceList;
	private BizPerformanceBean bizPerformance;
	private List<EmployeePerBean> employPerList;
	private List<BcustomerCountBean> customerCountList;

	private String userAccount;

	private String last_sync = "0";

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

	private String dateType = "day";

	public static final int WIDTH = 280;
	public static final int HEIGHT = 250;
	private PanelBar view;
	private LinearLayout columnarLayout;
	private LinearLayout annularLayout;
	private LinearLayout annular2Layout;

	private String year;

	private String day;

	private String month;

	@SuppressWarnings("deprecation")
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initData();
		initView();

	}
	
	Handler handle = new Handler() {
		public void handleMessage(Message msg) {
			
			if(msg.what==1)
			{
				String[] num = new String[employPerList.size()];
				String[] name = new String[employPerList.size()];
				float total = 0.0f;
				
				// 柱状图
				for(int i =0;i<employPerList.size();i++)
				{
					num[i] = employPerList.get(i).getTotal();
					name[i] = employPerList.get(i).getEmployee_name();
					total += Float.valueOf(employPerList.get(i).getTotal());  
				}
				columnarLayout = (LinearLayout) findViewById(R.id.columnarLayout);
				view = new PanelBar(getBaseContext(), num,name);
				columnarLayout.addView(view);
				
				total = (float)(Math.round(total*10))/10;
				((TextView)findViewById(R.id.employeetotal)).setText("￥"+total);
			}
			
			if(msg.what==2)
			{
				//newcard":13000,"recharge":10,"service":1900,"product":200
				float newcard = Float.valueOf(bizPerformance.getNewcard())/Float.valueOf(bizPerformance.getTotal());
				newcard = (float)(Math.round(newcard*1000))/10;
				float recharge = Float.valueOf(bizPerformance.getRecharge())/Float.valueOf(bizPerformance.getTotal());
				recharge = (float)(Math.round(recharge*1000))/10;
				float service = Float.valueOf(bizPerformance.getService())/Float.valueOf(bizPerformance.getTotal());
				service = (float)(Math.round(service*1000))/10;
				float product = Float.valueOf(bizPerformance.getProduct())/Float.valueOf(bizPerformance.getTotal());
				product = (float)(Math.round(product*1000))/10;
				
				float total = Float.valueOf(bizPerformance.getTotal());
				total = (float)(Math.round(total*10))/10;
				
				String[] perName = {"开卡业绩","充值业绩","服务业绩","卖品业绩"};
				// 环形图
				float[] num2 = new float[] { newcard, recharge, service, product };
				annularLayout = (LinearLayout) findViewById(R.id.annularLayout);
				PanelDountChart panelDountView = new PanelDountChart(getBaseContext(), num2,perName);
				annularLayout.addView(panelDountView);
				
				((TextView)findViewById(R.id.biztotal)).setText("￥"+total);
				((TextView)findViewById(R.id.sevicedata)).setText("￥"+bizPerformance.getService());
				((TextView)findViewById(R.id.saledata)).setText("￥"+bizPerformance.getProduct());
				((TextView)findViewById(R.id.carddata)).setText("￥"+bizPerformance.getNewcard());
				((TextView)findViewById(R.id.rechargedata)).setText("￥"+bizPerformance.getRecharge());
			}
			
			if(msg.what==3)
			{ 
				float total = 0.0f;
				int length = servicePerformanceList.size();
				float[] percentNum = new float[servicePerformanceList.size()];
				String[] projectName = new String[servicePerformanceList.size()];
				
				for(ServicePerformanceBean bean: servicePerformanceList)
				{
					//newcard":13000,"recharge":10,"service":1900,"product":200
					total += Float.valueOf(bean.getTotal());  
				}

				for(int i =0;i<length;i++)
				{
					float percent = Float.valueOf(servicePerformanceList.get(i).getTotal())/total;
					percentNum[i] = (float)(Math.round(percent*1000))/10;
					projectName[i] = servicePerformanceList.get(i).getProject_name();
				}
				
				// 环形图
				
				annular2Layout = (LinearLayout) findViewById(R.id.annular2Layout);
				PanelDountChart panelDountView = new PanelDountChart(getBaseContext(), percentNum,projectName);
				annular2Layout.addView(panelDountView);
				
				total = (float)(Math.round(total*10))/10;
				((TextView)findViewById(R.id.servicetotal)).setText("￥"+total);

			}
			
			if(msg.what==4)
			{
				DateUtil  dateUtil = new DateUtil();
				String[] yNum= dateUtil.getDayarr(year,month,dateType);
				int[] count = new int[yNum.length];
					for(int i=1;i<=yNum.length;i++)
					{
						count[i] = 0;
						for(BcustomerCountBean bean:customerCountList)
						{
							if(i==bean.getHour())
							{
								int daytotal = Integer.valueOf(bean.getMember()) +Integer.valueOf(bean.getMember());
								count[i] = daytotal;
							}
						}
					}
					
				
				// 折线图
				ChartView myView = (ChartView)findViewById(R.id.myView);
				myView.SetInfo(yNum, // Y轴刻度
						new String[] { "0", "10", "20", "30", "40", "50" }, // X轴刻度
						count// 数据
				);
			}
			
		}
	};

	public void initView() {
		select_shop = (ImageView) findViewById(R.id.headmore);
		shopname = (TextView) findViewById(R.id.shopname);
		showTime = (TextView) findViewById(R.id.showtime);
		lefttime = (ImageView) findViewById(R.id.lefttime);
		righttime = (ImageView) findViewById(R.id.righttime);
		timetype = (TextView) findViewById(R.id.timetype);

		shopname.setText(getIntent().getStringExtra("shopName"));
		showTime.setText(getDateNow());

		findViewById(R.id.goback).setVisibility(View.GONE);

		if (title == null || !(title.length > 0)) {
			select_shop.setVisibility(View.GONE);
		}
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
					curDate = dateUtil.getCurDate();
					showTime.setText(showtime);
				} else {
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy年MM月dd日");
					curDate = new Date(dateToCal(showTime.getText().toString(),
							formatter).getTimeInMillis() - 86400000);// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				}

				year = String.valueOf(curDate.getYear());
				day = String.valueOf(curDate.getDay());
				month = String.valueOf(curDate.getMonth());
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
					curDate = dateUtil.getCurDate();
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
				year = String.valueOf(curDate.getYear());
				day = String.valueOf(curDate.getDay());
				month = String.valueOf(curDate.getMonth());
				getShowData();
			}
		});

	}

	private void getShowData() 
	{
		getEmployeePerData();
		getBizPerformanceData();
		getServicePerformanceData();
		getBcustomerCount();
	}

	/**
	 * 员工业绩
	 */
	public void getEmployeePerData() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
				// ServerManageResponse res = ac.getReportsData(shopId, year,
				// month, dateType, day,"employee");
				ServerManageResponse res = ac.getReportsData(
						"100048101900800200", "2014", "5", dateType, "21",
						"employee");
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
					employeePerService.deltel("2014", "4", "21", dateType,
							tableName);
					
					employeePerService.addEmployeePer(employPerList, tableName);
					msg.what=1;
					handle.sendMessage(msg);
				}
			}
		}.start();
	}

	/**
	 * 服务业绩
	 */
	public void getBizPerformanceData() {
		
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
				// ServerManageResponse res = ac.getReportsData(shopId, year,
				// month, dateType, day,"employee");
				
				ServerManageResponse res = ac.getReportsData(
						"100048101900800200", "2014", "5", dateType, "21",
						"business");
				if (res.isSucess()) {
					
					String tableName = "biz_performance_day";
					if (dateType == "day") {
						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getDay();
						tableName = "biz_performance_day";
					} else if (dateType == "month") {
						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getMonth();
						tableName = "biz_performance_month";
					} else {
						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getWeek();
						tableName = "biz_performance_week";
					}
					// employeePerService.deltel(year, month, day, dateType,
					// tableName);
					bizPerformanceService.deltel("2014", "4", "21", dateType,
							tableName);
					bizPerformanceService.addBizPerformance(bizPerformance,
							tableName);
					msg.what=2;
					handle.sendMessage(msg);
				}
			}
		}.start();
	}

	/**
	 * 产品业绩
	 */
	public void getServicePerformanceData() {
	
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
				// ServerManageResponse res = ac.getReportsData(shopId, year,
				// month, dateType, day,"employee");
				ServerManageResponse res = ac.getReportsData(
						"100048101900800200", "2014", "5", dateType, "21",
						"service");
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
					productPerformanceService.deltel("2014", "4", "21",
							dateType, tableName);
					productPerformanceService.addProductPerformance(
							servicePerformanceList, tableName);
					msg.what=3;
					handle.sendMessage(msg);
				}
			}
		}.start();
	}

	/**
	 * 客流量
	 */
	public void getBcustomerCount() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerManageResponse res = ac.getReportsData("100048101900800200", "2014", "5", dateType, "21",
						"customer");
                if (res.isSucess()) {
					String tableName = "customer_count_day";
					if (dateType == "day") {
						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getHours();
						tableName = "customer_count_day";
					} else if(dateType == "week")
					{
						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getDays();
						tableName = "customer_count_week";
					}
					else {
						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getDays();
						tableName = "customer_count_month";
					}
					// employeePerService.deltel(year, month, day, dateType,
					// tableName);
					customerCountService.deltel("2014", "4", "21",
							dateType, tableName);
					customerCountService.addCustomerCount(
							customerCountList, tableName);
					msg.what=4;
					handle.sendMessage(msg);
				}

			}
		}.start();
	}

	/**
	 * 初始化底部栏
	 */
	private void initFootBar() {

		operate = (TextView) findViewById(R.id.operate);

		contacts = (TextView) findViewById(R.id.contacts);

		setting = (TextView) findViewById(R.id.setting);

		contacts.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), MemberGoupActivity.class);
				startActivity(contacts);
			}
		});

		setting.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent contacts = new Intent();
				contacts.setClass(getBaseContext(), SettingActivity.class);
				startActivity(contacts);
			}
		});

	}

	public void initData() {

		myshopService = new MyshopManageService(getBaseContext());
		employeePerService = new EmployeePerService(getBaseContext());
		productPerformanceService = new ProductPerformanceService(
				getBaseContext());
		bizPerformanceService = new BizPerformanceService(getBaseContext());
		customerCountService = new CustomerCountService(getBaseContext());
		
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		getShowData();

		// 查询本地的关联数据
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			shopId = myshops.get(0).getEnterprise_id();
			title = new String[myshops.size()];
			for (int i = 0; i < myshops.size(); i++) {
				title[i] = myshops.get(i).getEnterprise_name();
			}
		} else {
			// getLinkShop();
		}

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
		// showAsDropDown会把里面的view作为参照物，所以要那满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.LEFT
				| Gravity.TOP, x, y);// 需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				shopname.setText(title[arg2]);
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

	public String getDateNow() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		Date curDate = new Date(System.currentTimeMillis());// 获取当前时间
		year = String.valueOf(curDate.getYear());
		day = String.valueOf(curDate.getDay());
		month = String.valueOf(curDate.getMonth());
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
