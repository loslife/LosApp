package com.yilos.secretary;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.ScrollView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.BcustomerCountBean;
import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.bean.EmployeePerBean;
import com.yilos.secretary.bean.MyShopBean;
import com.yilos.secretary.bean.ServerManageResponse;
import com.yilos.secretary.bean.ServicePerformanceBean;
import com.yilos.secretary.chartview.EmployeeChartView;
import com.yilos.secretary.chartview.ServiceGoodsChartView;
import com.yilos.secretary.chartview.TrafficChartView;
import com.yilos.secretary.common.DateUtil;
import com.yilos.secretary.common.NetworkUtil;
import com.yilos.secretary.common.ScrollLayout;
import com.yilos.secretary.common.StringUtils;
import com.yilos.secretary.common.UIHelper;
import com.yilos.secretary.service.BizPerformanceService;
import com.yilos.secretary.service.CustomerCountService;
import com.yilos.secretary.service.EmployeePerService;
import com.yilos.secretary.service.MyshopManageService;
import com.yilos.secretary.service.ProductPerformanceService;

public class Main extends BaseActivity {

	private String shopId;
	private String shoptitle;

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

	private LinearLayout select_shop;

	private TextView shopname;

	private TextView showTime;
	private ImageView lefttime;
	private ImageView righttime;
	private TextView timetype;

	private ImageView customs_refresh;
	private ImageView employee_refresh;
	private ImageView service_refresh;
	private ImageView business_refresh;

	private PopupWindow popupWindow;
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
	// 获取4张报表，等于4则表示已全部获取
	public static int GETDATA_COUNT = 0;

	private EmployeeChartView view;
	private LinearLayout columnarLayout;
	private LinearLayout annularLayout;
	private LinearLayout annular2Layout;
	private LinearLayout myView;

	private ScrollLayout mainScrollLayout;
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
		userAccount = AppContext.getInstance(getBaseContext()).getUserAccount();

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
					// 服务业绩
					setBizPerformanceChartView();

					setEmployPerChartView();

					setServicePerChartView();

					setCustomerCountChartView();

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
					}
				}
				if (msg.what == 0) {
					loading_begin.setVisibility(View.GONE);
					mainScrollLayout.setVisibility(View.VISIBLE);
				}

				if ("日".equals(timetype.getText().toString())) {
					// 设置客流量的滚动条
					charscrollview = (ScrollView) findViewById(R.id.charscrollview);
					DisplayMetrics dm = getResources().getDisplayMetrics();
					charscrollview.smoothScrollTo(dm.widthPixels,
							(dm.widthPixels - 200) * 2 + 60
									- (dm.widthPixels - 200) / 6);
				}

			}
		};
	}

	// 绘制服务业绩
	private void setBizPerformanceChartView() {
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

		if (bizPerformance.getTotal() == null
				|| Float.valueOf(bizPerformance.getTotal()) == 0.0f) {
			((LinearLayout) findViewById(R.id.business_empty))
					.setVisibility(View.VISIBLE);
		} else {
			((LinearLayout) findViewById(R.id.business_empty))
					.setVisibility(View.GONE);
		}

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
			if (null != prevBizPerformance.get_id()) {
				prev_newcard = Float.valueOf(prevBizPerformance.getNewcard());
				comparePrevNewcard = Float.valueOf(bizPerformance.getNewcard())
						- prev_newcard;
				prev_recharge = Float.valueOf(prevBizPerformance.getRecharge());
				comparePrevRecharge = Float.valueOf(bizPerformance
						.getRecharge()) - prev_recharge;
				prev_service = Float.valueOf(prevBizPerformance.getService());
				comparePrevService = Float.valueOf(bizPerformance.getService())
						- prev_service;
				prev_product = Float.valueOf(prevBizPerformance.getProduct());
				comparePrevProduct = Float.valueOf(bizPerformance.getProduct())
						- prev_product;

				percent_newcard = (Math
						.round((comparePrevNewcard / prev_newcard) * 1000)) / 10;
				if (!(prev_newcard > 0)) {
					percent_newcard = +100.0f;
				}
				percent_recharge = (Math
						.round((comparePrevRecharge / prev_recharge) * 1000)) / 10;
				if (!(prev_recharge > 0)) {
					percent_recharge = +100.0f;
				}
				percent_service = (Math
						.round((comparePrevService / prev_service) * 1000)) / 10;
				if (!(prev_service > 0)) {
					percent_service = +100.0f;
				}
				percent_product = (Math
						.round((comparePrevProduct / prev_product) * 1000)) / 10;
				if (!(prev_product > 0)) {
					percent_product = +100.0f;
				}
			} else {
				comparePrevNewcard = Float.valueOf(bizPerformance.getNewcard());
				comparePrevRecharge = Float.valueOf(bizPerformance
						.getRecharge());
				comparePrevService = Float.valueOf(bizPerformance.getService());
				comparePrevProduct = Float.valueOf(bizPerformance.getProduct());

				percent_newcard = 100.0f;
				percent_recharge = 100.0f;
				percent_service = 100.0f;
				percent_product = 100.0f;
			}
		}

		String sevicedata = bizPerformance.getService() == null ? "0.0"
				: bizPerformance.getService();
		String saledata = bizPerformance.getProduct() == null ? "0.0"
				: bizPerformance.getProduct();
		String carddata = bizPerformance.getNewcard() == null ? "0.0"
				: bizPerformance.getNewcard();
		String rechargedata = bizPerformance.getRecharge() == null ? "0.0"
				: bizPerformance.getRecharge();
		((TextView) findViewById(R.id.biztotal)).setText("￥" + total);
		((TextView) findViewById(R.id.sevicedata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(sevicedata) * 10)) / 10);
		((TextView) findViewById(R.id.saledata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(saledata) * 10)) / 10);
		((TextView) findViewById(R.id.carddata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(carddata) * 10)) / 10);
		((TextView) findViewById(R.id.rechargedata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(rechargedata) * 10)) / 10);

		((TextView) findViewById(R.id.sevicedata)).setTextColor(getResources()
				.getColor(R.color.gray_text));
		((TextView) findViewById(R.id.saledata)).setTextColor(getResources()
				.getColor(R.color.gray_text));
		((TextView) findViewById(R.id.carddata)).setTextColor(getResources()
				.getColor(R.color.gray_text));
		((TextView) findViewById(R.id.rechargedata))
				.setTextColor(getResources().getColor(R.color.gray_text));

		((ImageView) findViewById(R.id.sevicesicon))
				.setImageResource(R.drawable.down);
		((ImageView) findViewById(R.id.saleicon))
				.setImageResource(R.drawable.down);
		((ImageView) findViewById(R.id.cardicon))
				.setImageResource(R.drawable.down);
		((ImageView) findViewById(R.id.rechargeicon))
				.setImageResource(R.drawable.down);

		comparePrevNewcard = (float) (Math.round(Float
				.valueOf(comparePrevNewcard) * 10)) / 10;
		comparePrevRecharge = (float) (Math.round(Float
				.valueOf(comparePrevRecharge) * 10)) / 10;
		comparePrevService = (float) (Math.round(Float
				.valueOf(comparePrevService) * 10)) / 10;
		comparePrevProduct = (float) (Math.round(Float
				.valueOf(comparePrevProduct) * 10)) / 10;
		((TextView) findViewById(R.id.toprev_sevicedata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevService
				+ " " + showPercent(percent_service) + "%");
		((TextView) findViewById(R.id.toprev_saledata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevProduct
				+ " " + showPercent(percent_product) + "%");
		((TextView) findViewById(R.id.toprev_carddata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevNewcard
				+ " " + showPercent(percent_newcard) + "%");
		((TextView) findViewById(R.id.toprev_rechargedata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevRecharge
				+ " " + showPercent(percent_recharge) + "%");

		if (comparePrevService > 0.0) {
			((ImageView) findViewById(R.id.sevicesicon))
					.setImageResource(R.drawable.up);
			((TextView) findViewById(R.id.sevicedata))
					.setTextColor(getResources().getColor(R.color.orange_bg));
		}

		if (comparePrevProduct > 0.0) {
			((ImageView) findViewById(R.id.saleicon))
					.setImageResource(R.drawable.up);
			((TextView) findViewById(R.id.saledata))
					.setTextColor(getResources().getColor(R.color.orange_bg));
		}

		if (comparePrevNewcard > 0.0) {
			((ImageView) findViewById(R.id.cardicon))
					.setImageResource(R.drawable.up);
			((TextView) findViewById(R.id.carddata))
					.setTextColor(getResources().getColor(R.color.orange_bg));
		}

		if (comparePrevRecharge > 0.0) {
			((ImageView) findViewById(R.id.rechargeicon))
					.setImageResource(R.drawable.up);
			((TextView) findViewById(R.id.rechargedata))
					.setTextColor(getResources().getColor(R.color.orange_bg));
		}

		newcard = (float) (Math.round(newcard * 1000)) / 10;
		recharge = (float) (Math.round(recharge * 1000)) / 10;
		service = (float) (Math.round(service * 1000)) / 10;
		product = (float) (Math.round(product * 1000)) / 10;

		String[] perName = { "开卡业绩", "充值业绩", "服务业绩", "卖品业绩" };
		// 环形图
		float[] num2 = new float[] { newcard, recharge, service, product };
		annularLayout = (LinearLayout) findViewById(R.id.annularLayout);
		annularLayout.removeAllViews();
		ServiceGoodsChartView panelDountView = new ServiceGoodsChartView(getBaseContext(),
				num2, perName, "business");
		annularLayout.addView(panelDountView);

		setButtonEnabled(true);

	}

	// 绘制卖品业绩报表
	private void setServicePerChartView() {
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
			((TextView) findViewById(R.id.othertext)).setText("其他");
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
		annular2Layout = (LinearLayout) findViewById(R.id.annular2Layout);
		annular2Layout.removeAllViews();
		ServiceGoodsChartView panelDountView = new ServiceGoodsChartView(getBaseContext(),
				percentNum, projectName, "service");
		annular2Layout.addView(panelDountView);

		total = (float) (Math.round(total * 10)) / 10;
		((TextView) findViewById(R.id.servicetotal)).setText("￥" + total);
		setOtherListView(otherPercentNum, otherProjectName, otherProjectTotal);
		if (total == 0.0f) {
			((LinearLayout) findViewById(R.id.service_empty))
					.setVisibility(View.VISIBLE);
		} else {
			((LinearLayout) findViewById(R.id.service_empty))
					.setVisibility(View.GONE);
		}
		setButtonEnabled(true);
	}

	// 绘制员工业绩报表
	private void setEmployPerChartView() {
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

		columnarLayout = (LinearLayout) findViewById(R.id.columnarLayout);
		columnarLayout.removeAllViews();
		EmployeeChartView view = new EmployeeChartView(getBaseContext(), num, name);
		columnarLayout.addView(view);

		total = (float) (Math.round(total * 10)) / 10;
		((TextView) findViewById(R.id.employeetotal)).setText("￥" + total);
		setButtonEnabled(true);

	}

	// 绘制客流量报表
	private void setCustomerCountChartView() {
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
		((TextView) findViewById(R.id.personNum)).setText("会员" + memberCount
				+ "人次  散客" + walkinCount + "人次");

		// 折线图
		myView = (LinearLayout) findViewById(R.id.myView);
		myView.removeAllViews();
		TrafficChartView chartView = new TrafficChartView(getBaseContext(), yNum, // Y轴刻度
				new String[] { "0", "10", "20", "30", "40", "50" }, // X轴刻度
				count// 数据
		);
		myView.addView(chartView);
		setButtonEnabled(true);
		loading_begin.setVisibility(View.GONE);
		mainScrollLayout.setVisibility(View.VISIBLE);
	}

	private void setOtherListView(float[] otherPercentNum,
			String[] otherProjectName, String[] otherProjectTotal) {
		// 绑定Layout里面的ListView
		ListView list = (ListView) findViewById(R.id.otherdata);
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
			SimpleAdapter listItemAdapter = new SimpleAdapter(this, listItem,// 数据源
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

	public void initView() {

		select_shop = (LinearLayout) findViewById(R.id.select_shop_layout);
		shopname = (TextView) findViewById(R.id.shopname);
		showTime = (TextView) findViewById(R.id.showtime);
		lefttime = (ImageView) findViewById(R.id.lefttime);
		righttime = (ImageView) findViewById(R.id.righttime);
		timetype = (TextView) findViewById(R.id.timetype);
		customs_refresh = (ImageView) findViewById(R.id.customs_refresh);
		employee_refresh = (ImageView) findViewById(R.id.employee_refresh);
		service_refresh = (ImageView) findViewById(R.id.service_refresh);
		business_refresh = (ImageView) findViewById(R.id.business_refresh);
		loading_begin = (LinearLayout) findViewById(R.id.loading_begin);

		mainScrollLayout = (ScrollLayout) findViewById(R.id.main_scrolllayout);
		noshop = (LinearLayout) findViewById(R.id.noshop);

		shopname.setText(AppContext.getInstance(getBaseContext()).getShopName());
		showTime.setText(getDateNow());
		select_shop.setTag(R.drawable.select_shop);

		((LinearLayout) findViewById(R.id.business_empty))
				.setVisibility(View.VISIBLE);

		findViewById(R.id.goback).setVisibility(View.GONE);

		customs_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
				loading_begin.setVisibility(View.VISIBLE);
				mainScrollLayout.setVisibility(View.GONE);
				getShowData();
			}
		});

		employee_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
				loading_begin.setVisibility(View.VISIBLE);
				mainScrollLayout.setVisibility(View.GONE);
				getShowData();
			}
		});

		service_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
				loading_begin.setVisibility(View.VISIBLE);
				mainScrollLayout.setVisibility(View.GONE);
				getShowData();
			}
		});

		business_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setButtonEnabled(false);
				loading_begin.setVisibility(View.VISIBLE);
				mainScrollLayout.setVisibility(View.GONE);
				getShowData();
			}
		});

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

		timetype.setOnClickListener(new OnClickListener() {

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

		lefttime.setOnClickListener(new OnClickListener() {

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

		righttime.setOnClickListener(new OnClickListener() {

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
				// 100048101900800200?year=2014&month=6&day=8&type=day&report=employee
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
			mainScrollLayout.setVisibility(View.GONE);

			// 获取报表
			getNetChartData();
		}

	}

	public void getlocalData() {
		// 服务业绩
		getLocalBizPerformanceData();
		// 员工业绩
		getLocalEmployeePerData();
		// 卖品业绩
		getLocalServicePerformanceData();
		// 客流量
		getLocalBcustomerCount();
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

	// 获取本地 员工业绩
	public void getLocalEmployeePerData() {

		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		// 获取本地数据
		if (dateType == "day") {
			employPerList = employeePerService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"employee_performance_day");
		} else if (dateType == "month") {
			employPerList = employeePerService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"employee_performance_month");
		} else {
			employPerList = employeePerService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"employee_performance_week");
		}

	}

	// 获取本地服务业绩
	public void getLocalBizPerformanceData() {
		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		List<BizPerformanceBean> bizPerformanceList = null;
		List<BizPerformanceBean> prevPerformanceList = null;

		int prevMonth = Integer.valueOf(month) - 2;
		int pevYear = Integer.valueOf(year);
		if (prevMonth == -1) {
			prevMonth = 12;
			pevYear = Integer.valueOf(year) - 1;
		}
		// 获取本地数据
		if (dateType == "day") {
			bizPerformanceList = bizPerformanceService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_day");
			prevPerformanceList = bizPerformanceService.queryListBydate(pevYear
					+ "", prevMonth + "", day, dateType, "biz_performance_day");

		} else if (dateType == "month") {
			bizPerformanceList = bizPerformanceService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_month");
			prevPerformanceList = bizPerformanceService.queryListBydate(pevYear
					+ "", prevMonth + "", day, dateType,
					"biz_performance_month");
		} else {
			bizPerformanceList = bizPerformanceService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"biz_performance_week");
			prevPerformanceList = bizPerformanceService.queryListBydate(pevYear
					+ "", prevMonth + "", DateUtil.getPreviousSundayNum() + "",
					dateType, "biz_performance_week");
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

	}

	// 获取本地 卖品业绩
	public void getLocalServicePerformanceData() {

		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		if (dateType == "day") {
			servicePerformanceList = productPerformanceService.queryListBydate(
					year, (Integer.valueOf(month) - 1) + "", day, dateType,
					"service_performance_day");
		} else if (dateType == "month") {
			servicePerformanceList = productPerformanceService.queryListBydate(
					year, (Integer.valueOf(month) - 1) + "", day, dateType,
					"service_performance_month");
		} else {
			servicePerformanceList = productPerformanceService.queryListBydate(
					year, (Integer.valueOf(month) - 1) + "", day, dateType,
					"service_performance_week");
		}

	}

	// 获取本地 客流量
	public void getLocalBcustomerCount() {

		shopId = AppContext.getInstance(getBaseContext())
				.getCurrentDisplayShopId();
		if (dateType == "day") {
			customerCountList = customerCountService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"customer_count_day");
		} else if (dateType == "month") {
			customerCountList = customerCountService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"customer_count_month");
		} else {
			customerCountList = customerCountService.queryListBydate(year,
					(Integer.valueOf(month) - 1) + "", day, dateType,
					"customer_count_week");
		}

		Message msg = new Message();
		msg.what = 1;
		handle.sendMessage(msg);

	}

	public void initData() {

		List<MyShopBean> myshops = myshopService.queryShops();
		if (myshops != null && myshops.size() > 0) {
			select_shop.setVisibility(View.VISIBLE);
			noshop.setVisibility(View.GONE);
			findViewById(R.id.date_header).setVisibility(View.VISIBLE);
			getShowData();
		} else {
			select_shop.setVisibility(View.GONE);
			loading_begin.setVisibility(View.GONE);
			mainScrollLayout.setVisibility(View.GONE);
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
		timetype.setEnabled(flag);
		lefttime.setEnabled(flag);
		righttime.setEnabled(flag);
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

	public String showPercent(float percent) {
		if (percent > 0.0f) {
			return "+" + percent;
		}

		return String.valueOf(percent);
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

}
