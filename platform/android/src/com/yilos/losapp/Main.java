package com.yilos.losapp;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.bean.ServerManageResponse;
import com.yilos.losapp.bean.ServerMemberResponse;
import com.yilos.losapp.common.DateUtil;
import com.yilos.losapp.common.UIHelper;
import com.yilos.losapp.service.EmployeePerService;
import com.yilos.losapp.service.MemberService;
import com.yilos.losapp.service.MyshopManageService;

import android.app.Activity;
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
import android.view.ViewGroup.LayoutParams;

public class Main extends BaseActivity {

	private TextView operate;

	private TextView contacts;

	private TextView setting;

	private String shopId;

	private MyshopManageService myshopService;
	private EmployeePerService employeePerService;

	private String userAccount;

	private String last_sync = "0";

	private ImageView select_shop;

	private TextView shopname;

	private TextView showTime;
	private ImageView lefttime;
	private ImageView righttime;
	private TextView timetype;

	private Button button;
	private PopupWindow popupWindow;
	private LinearLayout layout;
	private ListView listView;
	private String title[] = null;

	private String dateType = "day";

	public static final int WIDTH = 280;
	public static final int HEIGHT = 250;
	private PanelBar view;
	private PanelDountChart panelDountView;
	private LinearLayout columnarLayout;
	private LinearLayout annularLayout;
	
	private String year;
	
	private String day;
	
	private String month;
	
	@SuppressWarnings("deprecation")
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initData();
		initView();

		// 柱状图
		int[] num = {980, 650, 450,300 };
		columnarLayout = (LinearLayout) findViewById(R.id.columnarLayout);
		view = new PanelBar(this, num);
		columnarLayout.addView(view);

		// 环形图
		float[] num2 = new float[] { 20f, 30f, 10f, 40f };
		annularLayout = (LinearLayout) findViewById(R.id.annularLayout);
		panelDountView = new PanelDountChart(this, num2);
		annularLayout.addView(panelDountView);

		// 折线图
		ChartView myView = (ChartView) this.findViewById(R.id.myView);
		myView.SetInfo(new String[] { "7-11", "7-12", "7-13", "7-14", "7-15",
				"7-16", "7-17" }, // X轴刻度
				new String[] { "0", "10", "20", "30", "40", "50" }, // Y轴刻度
				new int[] { 15, 23, 10, 36, 45, 40, 12 } // 数据
		);

	}

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

				String showtime ="";
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
					curDate = new Date(dateToCal(
							showTime.getText().toString(), formatter)
							.getTimeInMillis() - 86400000);// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				}
				
				year = String.valueOf(curDate.getYear());
				day = String.valueOf(curDate.getDay());
				month = String.valueOf(curDate.getMonth());
				getEmployeePerData();
			}
		});

		righttime.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String showtime ="";
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
					curDate = new Date(dateToCal(
							showTime.getText().toString(), formatter)
							.getTimeInMillis() + 86400000);// 获取当前时间
					showtime = formatter.format(curDate);
					showTime.setText(showtime);
				}
				//100048101900800200?year=2014&month=6&day=8&type=day&report=employee
                year = String.valueOf(curDate.getYear());
				day = String.valueOf(curDate.getDay());
				month = String.valueOf(curDate.getMonth());
				getEmployeePerData();
			}
		});

	}
	
	private void shiftView()
	{
		
	}
	
	/**
	 * 员工业绩
	 */
	public void getEmployeePerData()
	{
		final Handler handle = new Handler() {
			public void handleMessage(Message msg) {
				
			}
		};
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					//100048101900800200?year=2014&month=6&day=8&type=day&report=employee
					//ServerManageResponse res = ac.getReportsData(shopId, year, month, dateType, day,"employee");
					ServerManageResponse res = ac.getReportsData("100048101900800200", "2014", "5", dateType, "21","employee");
					if (res.isSucess()) {
						List<EmployeePerBean> employPerList;
						String tableName = "employee_performance_day";
						if (dateType == "day") 
						{
							employPerList = res.getResult().getCurrent().getTb_emp_performance().getDay();
							tableName = "employee_performance_day";
						}
						else if(dateType == "month")
						{
							employPerList = res.getResult().getCurrent().getTb_emp_performance().getMonth();
							tableName = "employee_performance_month";
						}
						else
						{
							employPerList = res.getResult().getCurrent().getTb_emp_performance().getWeek();
							tableName = "employee_performance_week";
						}
						//employeePerService.deltel(year, month, day, dateType, tableName);
						employeePerService.deltel("2014", "4","21",dateType, tableName);
						employeePerService.addEmployeePer(employPerList, tableName);
					}
				}
			}.start();
	}
	
	/**
	 * 服务业绩
	 */
	public void getBizPerformanceData()
	{
		final Handler handle = new Handler() {
			public void handleMessage(Message msg) {
				
			}
		};
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					ServerManageResponse res = ac.getReportsData(shopId, year, month, dateType, day,"business");
				}
			}.start();
	}
	
	/**
	 * 产品业绩
	 */
	public void getServicePerformanceData()
	{
		final Handler handle = new Handler() {
			public void handleMessage(Message msg) {
				
			}
		};
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					ac.getReportsData(shopId, year, month, dateType, day,"service");
					
				}
			}.start();
	}
	
	/**
	 * 客流量
	 */
	public void getBcustomerCount()
	{
		final Handler handle = new Handler() {
			public void handleMessage(Message msg) {
				
			}
		};
			new Thread() {
				public void run() {
					AppContext ac = (AppContext) getApplication();
					Message msg = new Message();
					ac.getReportsData(shopId, year, month, dateType, day,"customer");
					
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
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();
		getEmployeePerData();

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

	public void getLinkShop() {

		final Handler handle = new Handler() {
			public void handleMessage(Message msg) {
				if (msg.what == 1) {
					List<MyShopBean> myshops = myshopService.queryShops();
					if (myshops != null && myshops.size() > 0) {
						shopId = myshops.get(0).getEnterprise_id();
						last_sync = myshops.get(0).getLatest_sync();
						AppContext.getInstance(getBaseContext())
								.setCurrentDisplayShopId(shopId);
						// AppContext.getInstance(getBaseContext()).setLastSyncTime(last_sync);
					} else {
						UIHelper.ToastMessage(getBaseContext(), "没有关联店铺");
					}

					title = new String[myshops.size()];
					for (int i = 0; i < myshops.size(); i++) {
						title[i] = myshops.get(i).getEnterprise_name();
					}
				}
				if (msg.what == 0) {

				}
			}

		};
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerMemberResponse res = ac.getMyshopList(userAccount);
				if (res.isSucess()) {
					myshopService.addShops(res.getResult().getMyShopList());
					msg.what = 1;
				}
				if (res.getCode() == 1) {
					msg.what = 0;
				}
				handle.sendMessage(msg);
			}
		}.start();
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
