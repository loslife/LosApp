package com.yilos.secretary;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.yilos.secretary.bean.BcustomerCountBean;
import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.bean.EmployeePerBean;
import com.yilos.secretary.bean.IncomePerformanceBean;
import com.yilos.secretary.bean.MyShopBean;
import com.yilos.secretary.bean.ServerManageResponse;
import com.yilos.secretary.bean.ServicePerformanceBean;
import com.yilos.secretary.common.DateUtil;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.service.BizPerformanceService;
import com.yilos.secretary.service.CustomerCountService;
import com.yilos.secretary.service.EmployeePerService;
import com.yilos.secretary.service.IncomePerformanceService;
import com.yilos.secretary.service.MyshopManageService;
import com.yilos.secretary.service.ProductPerformanceService;
import com.yilos.secretary.view.BizPerformanceView;
import com.yilos.secretary.view.CustomerCountView;
import com.yilos.secretary.view.EmployPerView;
import com.yilos.secretary.view.IncomePerformanceView;
import com.yilos.secretary.view.RefreshLayoutableView;
import com.yilos.secretary.view.ServicePerView;

public class Main extends BaseActivity implements
		RefreshLayoutableView.RefreshListener {

	private String shopId;
	private String shoptitle;

	private MyshopManageService myshopService;
	private EmployeePerService employeePerService;
	private ProductPerformanceService productPerformanceService;
	private BizPerformanceService bizPerformanceService;
	private CustomerCountService customerCountService;
	private IncomePerformanceService incomeperformancService;

	private List<ServicePerformanceBean> servicePerformanceList;
	private BizPerformanceBean bizPerformance;
	private BizPerformanceBean prevBizPerformance;
	private IncomePerformanceBean incomeperformance;
	private IncomePerformanceBean prevIncomePerformance;
	private List<EmployeePerBean> employPerList;
	private List<BcustomerCountBean> customerCountList;

	private LinearLayout select_shop;
	private TextView shopname;
	private TextView showTime;
	private ImageView lefttime;
	private ImageView righttime;
	private TextView timetype;

	private PopupWindow popupWindow;

	private RelativeLayout lefttime_layout;
	private RelativeLayout righttime_layout;
	private RelativeLayout timetype_layout;
	private RefreshLayoutableView mRefreshBusinessView;
	private RefreshLayoutableView mRefreshEmployeeView;
	private RefreshLayoutableView mRefreshServiceView;
	private RefreshLayoutableView mRefreshTrafficView;
	private RefreshLayoutableView mRefreshIncomeView;
	private LinearLayout layout;
	private ListView listView;
	private LinearLayout loading_begin;

	private ScrollView charscrollview;
	private String title[] = null;
	private String titleList[] = null;
	private String shopIds[] = null;
	private String dateType = "day";

	public static final int WIDTH = 280;
	public static final int HEIGHT = 250;
	// 获取5张报表，等于5则表示已全部获取
	public static int GETDATA_COUNT = 0;
	
	private View bizPerformanceView;
	private View employPerView;
	private View servicePerView;
	private View customerCountView;
	private View incomePerView;
	
	private ViewPager viewPager;  
	private ArrayList<View> pageViews;  

	private ViewPager mainScrollLayout;
	private LinearLayout noshop;
	private Handler handle;

	public static long datetime;

	private String year;
	private String day;
	private String month;

	@SuppressWarnings("deprecation")
	public void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		myshopService = new MyshopManageService(getBaseContext());
		employeePerService = new EmployeePerService(getBaseContext());
		productPerformanceService = new ProductPerformanceService(
				getBaseContext());
		bizPerformanceService = new BizPerformanceService(getBaseContext());
		customerCountService = new CustomerCountService(getBaseContext());
		incomeperformancService = new IncomePerformanceService(getBaseContext());

		// 进程被杀后，需要重新加载
		AppContext.getInstance(getBaseContext()).setChangeShop(true);

		if (null == shopId) {
			shopId = "";
		}
		if (!"".equals(shopId)
				&& AppContext.getInstance(getBaseContext()).isFirstRun()) {
			Intent intent = new Intent(getBaseContext(), LayerActivity.class);
			startActivity(intent);
			AppContext.getInstance(getBaseContext()).setFirstRun(false);
		}
		initView();
		this.initChartViewData();
		getlocalData();
	}

	public void onResume() {
		super.onResume();

		shoptitle = AppContext.getInstance(getBaseContext()).getShopName();
		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		if (null == shopId) {
			shopId = "";
		}
		// 查询本地的关联数据
		queiryTitleList();
		if (AppContext.getInstance(getBaseContext()).isChangeShop()) {
			initData();
			AppContext.getInstance(getBaseContext()).setChangeShop(false);
		}
	}

	private void initChartViewData() {
		handle = new Handler() {
			public void handleMessage(Message msg) {
				if (msg.what == 1) {
					
					// 经营收入
					IncomePerformanceView iview = new IncomePerformanceView(); 
					iview.setIncomePerChartView(getBaseContext(),
					      incomePerView, timetype, incomeperformance,
					      prevIncomePerformance);
					
					// 服务业绩
					BizPerformanceView bview = new BizPerformanceView();
					bview.setBizPerformanceChartView(getBaseContext(),
							bizPerformanceView, timetype, bizPerformance,
							prevBizPerformance);
					
					incomePerView.findViewById(R.id.updatetip).setVisibility(View.GONE);
					if(incomeperformance.get_id()==null&&bizPerformance.get_id()!=null)
					{
						incomePerView.findViewById(R.id.updatetip).setVisibility(View.VISIBLE);
					}

					// 员工业绩
					EmployPerView eview = new EmployPerView();
					eview.setEmployPerChartView(getBaseContext(),
							employPerView, employPerList);

					// 卖品业绩
					ServicePerView sview = new ServicePerView();
					sview.setServicePerChartView(getBaseContext(),
							servicePerView, servicePerformanceList);

					// 客流量
					CustomerCountView cview = new CustomerCountView();
					cview.setCustomerCountChartView(getBaseContext(),
							customerCountView, customerCountList, year, month,
							day, dateType);
					
					setButtonEnabled(true);
					loading_begin.setVisibility(View.GONE);
					List<MyShopBean> myshops = myshopService.queryShops();
					if (myshops != null && myshops.size() > 0) {
						findViewById(R.id.main_viewpager).setVisibility(View.VISIBLE);
					}
					
					if (NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE) {
						// 保存服务业绩
						bizPerformanceService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day,
								dateType, "biz_performance_" + dateType);

						if (prevBizPerformance.get_id() != null) {
							bizPerformanceService.deltel(
									prevBizPerformance.getYear(),
									prevBizPerformance.getMonth(),
									prevBizPerformance.getDay(), dateType,
									"biz_performance_" + dateType);
						}

						bizPerformanceService.addBizPerformance(bizPerformance,
								"biz_performance_" + dateType);
						bizPerformanceService.addBizPerformance(
								prevBizPerformance, "biz_performance_"
										+ dateType);

						// 保存员工
						employeePerService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day,
								dateType, "employee_performance_" + dateType);

						employeePerService.addEmployeePer(employPerList,
								"employee_performance_" + dateType);

						// 保存卖品
						productPerformanceService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day,
								dateType, "service_performance_" + dateType);
						productPerformanceService.addProductPerformance(
								servicePerformanceList, "service_performance_"
										+ dateType);

						// 保存客流量
						customerCountService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day,
								dateType, "customer_count_" + dateType);
						customerCountService
								.addCustomerCount(customerCountList,
										"customer_count_" + dateType);
						
						// 保存经营收入
						incomeperformancService.deltel(year,
								(Integer.valueOf(month) - 1) + "", day,
								dateType, "income_performance_" + dateType);

						if (prevIncomePerformance.get_id() != null) {
							incomeperformancService.deltel(
									prevIncomePerformance.getYear(),
									prevIncomePerformance.getMonth(),
									prevIncomePerformance.getDay(), dateType,
									"income_performance_" + dateType);
						}

						incomeperformancService.addIncomePerformance(incomeperformance,
								"income_performance_" + dateType);
						incomeperformancService.addIncomePerformance(
								prevIncomePerformance, "income_performance_"
										+ dateType);
					}
					viewFinishRefresh();
				}
				if (msg.what == 0) {
					loading_begin.setVisibility(View.GONE);
					findViewById(R.id.main_viewpager).setVisibility(View.VISIBLE);
				}
				if (msg.what == 2) {
					viewFinishRefresh();
					UIHelper.ToastMessage(getBaseContext(), "网络不给力");
				}
				if ("日".equals(timetype.getText().toString())) {
					// 设置客流量的滚动条
					charscrollview = (ScrollView) mRefreshTrafficView.findViewById(R.id.charscrollview);
					DisplayMetrics dm = getResources().getDisplayMetrics();
					charscrollview.smoothScrollTo(dm.widthPixels,
							(dm.widthPixels - 200) * 2 + 60
									- (dm.widthPixels - 200) / 6);
				}
			}
		};
	}

	public void initView() {
		select_shop = (LinearLayout) findViewById(R.id.select_shop_layout);
		shopname = (TextView) findViewById(R.id.shopname);
		showTime = (TextView) findViewById(R.id.showtime);
		lefttime = (ImageView) findViewById(R.id.lefttime);
		righttime = (ImageView) findViewById(R.id.righttime);
		timetype = (TextView) findViewById(R.id.timetype);
		loading_begin = (LinearLayout) findViewById(R.id.loading_begin);
		mainScrollLayout = (ViewPager) findViewById(R.id.main_scrolllayout);
		lefttime_layout = (RelativeLayout) findViewById(R.id.lefttime_layout);
		righttime_layout = (RelativeLayout) findViewById(R.id.righttime_layout);
		timetype_layout = (RelativeLayout) findViewById(R.id.timetype_layout);
		noshop = (LinearLayout) findViewById(R.id.noshop);

		incomePerView = LayoutInflater.from(getBaseContext()).inflate(
				R.layout.incomeperformance_chart, null);
		bizPerformanceView = LayoutInflater.from(getBaseContext()).inflate(
				R.layout.business_chart, null);
		employPerView = LayoutInflater.from(getBaseContext()).inflate(
				R.layout.employee_chart, null);
		servicePerView = LayoutInflater.from(getBaseContext()).inflate(
				R.layout.service_chart, null);
		customerCountView = LayoutInflater.from(getBaseContext()).inflate(
				R.layout.traffic_chart, null);
		
		pageViews = new ArrayList<View>();  
        pageViews.add(incomePerView);  
        pageViews.add(bizPerformanceView);  
        pageViews.add(employPerView);  
        pageViews.add(servicePerView);
        pageViews.add(customerCountView); 
  
        mainScrollLayout.setAdapter(new GuidePageAdapter());  
        mainScrollLayout.setOnPageChangeListener(new GuidePageChangeListener());  
		
		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		showTime.setText(getDateNow());
		select_shop.setTag(R.drawable.select_shop);

		mRefreshIncomeView = (RefreshLayoutableView) incomePerView.findViewById(R.id.refresh_income);
		mRefreshIncomeView.setRefreshListener(this);

		mRefreshBusinessView = (RefreshLayoutableView) bizPerformanceView.findViewById(R.id.refresh_business);
		mRefreshBusinessView.setRefreshListener(this);

		mRefreshServiceView = (RefreshLayoutableView) servicePerView.findViewById(R.id.refresh_service);
		mRefreshServiceView.setRefreshListener(this);

		mRefreshEmployeeView = (RefreshLayoutableView) employPerView.findViewById(R.id.refresh_employee);
		mRefreshEmployeeView.setRefreshListener(this);

		mRefreshTrafficView = (RefreshLayoutableView) customerCountView.findViewById(R.id.refresh_traffic);
		mRefreshTrafficView.setRefreshListener(this);
		
		findViewById(R.id.goback).setVisibility(View.GONE);
		
		select_shop.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				((ImageView) findViewById(R.id.headmore)).getRight();
				int y = ((ImageView) findViewById(R.id.headmore)).getBottom() * 2;
				int x = getWindowManager().getDefaultDisplay().getWidth() / 2;
				LinearLayout image = (LinearLayout) v;
				Integer integer = (Integer) image.getTag();
				integer = integer == null ? 0 : integer;
				if (integer == R.drawable.select_shop) {
					((ImageView) findViewById(R.id.headmore))
							.setImageDrawable(getBaseContext().getResources()
									.getDrawable(R.drawable.retract));
					select_shop.setTag(R.drawable.retract);
				} else {
					((ImageView) findViewById(R.id.headmore))
							.setImageDrawable(getBaseContext().getResources()
									.getDrawable(R.drawable.select_shop));
					select_shop.setTag(R.drawable.select_shop);
				}
				showPopupWindow(x, y);
			}
		});

		timetype_layout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
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

		lefttime_layout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
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
				month = String.valueOf(curDate.getMonth() + 1);
				getShowData();
			}
		});

		righttime_layout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
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
				year = String.valueOf(curDate.getYear() + 1900);
				day = String.valueOf(curDate.getDate());
				month = String.valueOf(curDate.getMonth() + 1);
				getShowData();
			}
		});

	}

	/**
	 * 获得数据
	 */
	private void getShowData() {

		if (NetworkUtil.checkNetworkIsOk(getBaseContext()) == NetworkUtil.NONE) {
			getlocalData();
		} else {
			loading_begin.setVisibility(View.VISIBLE);
			findViewById(R.id.main_viewpager).setVisibility(View.GONE);

			// 获取报表
			getNetChartData();
		}
	}

	public void getlocalData() {
		// 服务业绩
		bizPerformance = bizPerformanceService.getLocalBizPerformanceData(
				dateType, year, month, day, 0);
		prevBizPerformance = bizPerformanceService.getLocalBizPerformanceData(
				dateType, year, month, day, 1);
		// 员工业绩
		employPerList = employeePerService.getLocalEmployeePerData(dateType,
				year, month, day);
		// 卖品业绩
		servicePerformanceList = productPerformanceService
				.getLocalServicePerformanceData(dateType, year, month, day);
		// 客流量
		customerCountList = customerCountService.getLocalBcustomerCount(
				dateType, year, month, day);

		 // 经营收入
		 incomeperformance = incomeperformancService.getLocalIncomePerformanceData( dateType,
		 year, month, day, 0);
		 
		 prevIncomePerformance = incomeperformancService.getLocalIncomePerformanceData( dateType,
		 year, month, day, 1);
		 
		Message msg = new Message();
		msg.what = 1;
		handle.sendMessage(msg);
	}

	/**
	 * 获取报表数据
	 */
	public void getNetChartData() {
		new Thread() {
			public void run() {
				AppContext ac = (AppContext) getApplication();
				Message msg = new Message();
				ServerManageResponse res = ac.getReportsData(shopId, year,
						month, dateType, day, null);
				if (res.isSucess()) {
					// 服务业绩
					if (dateType == "day") {
						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getDay();
						prevBizPerformance = res.getResult().getPrev()
								.getTb_biz_performance().getDay();

						employPerList = res.getResult().getCurrent()
								.getTb_emp_performance().getDay();

						servicePerformanceList = res.getResult().getCurrent()
								.getTb_service_performance().getDay();

						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getHours();

						incomeperformance = res.getResult().getCurrent()
								.getTb_income_performance().getDay();
						prevIncomePerformance = res.getResult().getPrev()
								.getTb_income_performance().getDay();

					} else if (dateType == "month") {

						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getMonth();
						prevBizPerformance = res.getResult().getPrev()
								.getTb_biz_performance().getMonth();

						employPerList = res.getResult().getCurrent()
								.getTb_emp_performance().getMonth();

						servicePerformanceList = res.getResult().getCurrent()
								.getTb_service_performance().getMonth();

						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getDays();

						incomeperformance = res.getResult().getCurrent()
								.getTb_income_performance().getMonth();
						prevIncomePerformance = res.getResult().getPrev()
								.getTb_income_performance().getMonth();

					} else {

						bizPerformance = res.getResult().getCurrent()
								.getTb_biz_performance().getWeek();
						prevBizPerformance = res.getResult().getPrev()
								.getTb_biz_performance().getWeek();

						employPerList = res.getResult().getCurrent()
								.getTb_emp_performance().getWeek();

						servicePerformanceList = res.getResult().getCurrent()
								.getTb_service_performance().getWeek();

						customerCountList = res.getResult().getCurrent()
								.getB_customer_count().getDays();

						incomeperformance = res.getResult().getCurrent()
								.getTb_income_performance().getWeek();
						prevIncomePerformance = res.getResult().getPrev()
								.getTb_income_performance().getWeek();
					}
					msg.what = 1;
					handle.sendMessage(msg);
				} else {
					msg.what = 0;
					handle.sendMessage(msg);
				}
			}
		}.start();

	}

	public void initData() {
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			select_shop.setVisibility(View.VISIBLE);
			noshop.setVisibility(View.GONE);
			findViewById(R.id.main_viewpager).setVisibility(View.VISIBLE);
			findViewById(R.id.date_header).setVisibility(View.VISIBLE);
			getShowData();
		} else {
			select_shop.setVisibility(View.GONE);
			loading_begin.setVisibility(View.GONE);
			findViewById(R.id.main_viewpager).setVisibility(View.GONE);
			noshop.setVisibility(View.VISIBLE);
			findViewById(R.id.date_header).setVisibility(View.GONE);
			shopname.setText("我的店铺");
		}
	}

	public void queiryTitleList() {
		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			title = new String[myshops.size()];
			titleList = new String[myshops.size()];
			shopIds = new String[myshops.size()];
			for (int i = 0; i < myshops.size(); i++) {
				title[i] = myshops.get(i).getEnterprise_name();
				titleList[i] = "• " + myshops.get(i).getEnterprise_name();
				if (myshops.get(i).getEnterprise_name() == null
						|| "".equals(myshops.get(i).getEnterprise_name())) {
					title[i] = "我的店铺";
					titleList[i] = "• 我的店铺";
				}
				shopIds[i] = myshops.get(i).getEnterprise_id();
			}
			if (shoptitle == null || "".equals(shoptitle)) {
				shoptitle = "我的店铺";
			}
			shopname.setText(shoptitle);
		}
	}

	public void showPopupWindow(int x, int y) {
		layout = (LinearLayout) LayoutInflater.from(Main.this).inflate(
				R.layout.dialog, null);
		listView = (ListView) layout.findViewById(R.id.lv_dialog);
		listView.setAdapter(new ArrayAdapter<String>(Main.this, R.layout.text,
				R.id.tv_text, titleList) {
			// 在这个重写的函数里设置 每个 item 中按钮的响应事件
			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				final View view = super.getView(position, convertView, parent);
				if (shopIds[position].equals(shopId)) {
					((TextView) view.findViewById(R.id.tv_text))
							.setTextColor(getBaseContext().getResources()
									.getColor(R.color.paneldount_one));
				} else {
					((TextView) view.findViewById(R.id.tv_text))
							.setTextColor(getBaseContext().getResources()
									.getColor(R.color.blue_text));
				}
				return view;
			}
		});

		popupWindow = new PopupWindow(Main.this);
		popupWindow.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {
				((ImageView) findViewById(R.id.headmore))
						.setImageDrawable(getBaseContext().getResources()
								.getDrawable(R.drawable.select_shop));
				select_shop.setTag(R.drawable.select_shop);
			}
		});
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow
				.setWidth(getWindowManager().getDefaultDisplay().getWidth() * 2 / 5);
		if (title.length < 5) {
			popupWindow.setHeight(title.length
					* (getWindowManager().getDefaultDisplay().getWidth() / 10)
					+ 10);
		} else {
			popupWindow.setHeight(5 * (getWindowManager().getDefaultDisplay()
					.getWidth() / 10) + 10);
		}
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		// showAsDropDown会把里面的view作为参照物，满屏幕parent
		popupWindow.showAtLocation(findViewById(R.id.headmore), Gravity.CENTER
				| Gravity.TOP, x, y);// 需要指定Gravity，默认情况是center.

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				if (shopId.equals(shopIds[arg2])) {
					if (null != popupWindow) {
						popupWindow.dismiss();
					}
					popupWindow = null;
					((ImageView) findViewById(R.id.headmore))
							.setImageDrawable(getBaseContext().getResources()
									.getDrawable(R.drawable.select_shop));
					return;
				}
				shopname.setText(title[arg2]);
				AppContext.getInstance(getBaseContext()).setShopName(
						title[arg2]);
				AppContext.getInstance(getBaseContext())
						.setCurrentDisplayShopId(shopIds[arg2]);
				shopId = shopIds[arg2];
				getShowData();
				((ImageView) findViewById(R.id.headmore))
						.setImageDrawable(getBaseContext().getResources()
								.getDrawable(R.drawable.select_shop));
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

	public void setButtonEnabled(boolean flag) {
		timetype_layout.setEnabled(flag);
		lefttime_layout.setEnabled(flag);
		righttime_layout.setEnabled(flag);
		if (!flag) {
			lefttime.setImageDrawable(getBaseContext().getResources()
					.getDrawable(R.drawable.graytoleft));
			righttime.setImageDrawable(getBaseContext().getResources()
					.getDrawable(R.drawable.graytoright));
			timetype.setTextColor(getBaseContext().getResources().getColor(
					R.color.gray_text));
		} else {
			lefttime.setImageDrawable(getBaseContext().getResources()
					.getDrawable(R.drawable.toleft));
			righttime.setImageDrawable(getBaseContext().getResources()
					.getDrawable(R.drawable.toright));
			timetype.setTextColor(getBaseContext().getResources().getColor(
					R.color.blue_text));
		}
	}

	public String getDateNow() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		Date curDate = new Date(System.currentTimeMillis());// 获取当前时间
		year = String.valueOf(curDate.getYear() + 1900);
		day = String.valueOf(curDate.getDate());
		month = String.valueOf(curDate.getMonth() + 1);
		String str = formatter.format(curDate);
		return str;
	}

	//这个方法不可以提出去
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

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent i = new Intent(Intent.ACTION_MAIN);
			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			i.addCategory(Intent.CATEGORY_HOME);
			startActivity(i);
			return false;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	@Override
	public void onRefresh(RefreshLayoutableView view) {
		if (NetworkUtil.checkNetworkIsOk(getBaseContext()) != NetworkUtil.NONE) {
			getNetChartData();
		}
		else
		{
			handle.sendEmptyMessageDelayed(2, 2000l);
		}
	}
	
	public void viewFinishRefresh()
	{
		mRefreshIncomeView.finishRefresh();
		mRefreshBusinessView.finishRefresh();
		mRefreshEmployeeView.finishRefresh();
		mRefreshServiceView.finishRefresh();
		mRefreshTrafficView.finishRefresh();
	}
	
    /** 指引页面Adapter */
    class GuidePageAdapter extends PagerAdapter {  
    	  
        @Override  
        public int getCount() {  
            return pageViews.size();  
        }  
  
        @Override  
        public boolean isViewFromObject(View arg0, Object arg1) {  
            return arg0 == arg1;  
        }  
  
        @Override  
        public int getItemPosition(Object object) {  
            return super.getItemPosition(object);  
        }  
  
        @Override  
        public void destroyItem(View arg0, int arg1, Object arg2) {   
            ((ViewPager) arg0).removeView(pageViews.get(arg1));  
        }  
  
        @Override  
        public Object instantiateItem(View arg0, int arg1) {  
            ((ViewPager) arg0).addView(pageViews.get(arg1));  
            return pageViews.get(arg1);  
        }  
  
        @Override  
        public void restoreState(Parcelable arg0, ClassLoader arg1) {  
        }  
  
        @Override  
        public Parcelable saveState() {  
            return null;  
        }  
  
        @Override  
        public void startUpdate(View arg0) {  
        }  
  
        @Override  
        public void finishUpdate(View arg0) {  
        }  
    } 
    
    /** 指引页面改监听器 */
    class GuidePageChangeListener implements OnPageChangeListener {  
  
        @Override  
        public void onPageScrollStateChanged(int arg0) {  
        }  
  
        @Override  
        public void onPageScrolled(int arg0, float arg1, int arg2) {  
        }  
  
        @Override  
        public void onPageSelected(int arg0) {  
            }
        }  
}
