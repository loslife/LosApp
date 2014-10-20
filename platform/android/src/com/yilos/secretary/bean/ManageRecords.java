package com.yilos.secretary.bean;

import java.util.ArrayList;
import java.util.List;

public class ManageRecords 
{
	public TbbizPerformance tb_biz_performance;
	
	public TbempPerformance tb_emp_performance;
	
	public TbservicePerformance tb_service_performance;
	
	public BcustomerCount b_customer_count;
	
	public IncomePerformance tb_income_performance;
	
	 public static class TbservicePerformance {
		 
		    private List<ServicePerformanceBean> day = new ArrayList<ServicePerformanceBean>();
			
			private List<ServicePerformanceBean> week = new ArrayList<ServicePerformanceBean>();
			
			private List<ServicePerformanceBean> month = new ArrayList<ServicePerformanceBean>();

			public List<ServicePerformanceBean> getDay() {
				return day;
			}

			public void setDay(List<ServicePerformanceBean> day) {
				this.day = day;
			}

			public List<ServicePerformanceBean> getWeek() {
				return week;
			}

			public void setWeek(List<ServicePerformanceBean> week) {
				this.week = week;
			}

			public List<ServicePerformanceBean> getMonth() {
				return month;
			}

			public void setMonth(List<ServicePerformanceBean> month) {
				this.month = month;
			}

	 }
	 
	 public static class TbempPerformance {
		 
		    private List<EmployeePerBean> day = new ArrayList<EmployeePerBean>();
			
			private List<EmployeePerBean> week = new ArrayList<EmployeePerBean>();
			
			private List<EmployeePerBean> month = new ArrayList<EmployeePerBean>();
			
			public List<EmployeePerBean> getDay() {
				return day;
			}

			public void setDay(List<EmployeePerBean> day) {
				this.day = day;
			}

			public List<EmployeePerBean> getWeek() {
				return week;
			}

			public void setWeek(List<EmployeePerBean> week) {
				this.week = week;
			}

			public List<EmployeePerBean> getMonth() {
				return month;
			}

			public void setMonth(List<EmployeePerBean> month) {
				this.month = month;
			}
	 }
	 
	 public static class TbbizPerformance {
		 
		    private BizPerformanceBean day = new BizPerformanceBean();
			
			private BizPerformanceBean week = new BizPerformanceBean();
			
			private BizPerformanceBean month = new BizPerformanceBean();

			public BizPerformanceBean getDay() {
				return day;
			}

			public void setDay(BizPerformanceBean day) {
				this.day = day;
			}

			public BizPerformanceBean getWeek() {
				return week;
			}

			public void setWeek(BizPerformanceBean week) {
				this.week = week;
			}

			public BizPerformanceBean getMonth() {
				return month;
			}

			public void setMonth(BizPerformanceBean month) {
				this.month = month;
			}

	 }
	 
	 public static class BcustomerCount {
		 
		    private List<BcustomerCountBean> days = new ArrayList<BcustomerCountBean>();
			
			private List<BcustomerCountBean> hours = new ArrayList<BcustomerCountBean>();

			public List<BcustomerCountBean> getDays() {
				return days;
			}

			public void setDays(List<BcustomerCountBean> days) {
				this.days = days;
			}

			public List<BcustomerCountBean> getHours() {
				return hours;
			}

			public void setHours(List<BcustomerCountBean> hours) {
				this.hours = hours;
			}
			
	 }
	 
	 public static class IncomePerformance {
		 
		    private IncomePerformanceBean day = new IncomePerformanceBean();
			
            private IncomePerformanceBean week = new IncomePerformanceBean();
			
			private IncomePerformanceBean month = new IncomePerformanceBean();

			public IncomePerformanceBean getDay() {
				return day;
			}

			public void setDay(IncomePerformanceBean day) {
				this.day = day;
			}

			public IncomePerformanceBean getWeek() {
				return week;
			}

			public void setWeek(IncomePerformanceBean week) {
				this.week = week;
			}

			public IncomePerformanceBean getMonth() {
				return month;
			}

			public void setMonth(IncomePerformanceBean month) {
				this.month = month;
			}

	 }

	public TbbizPerformance getTb_biz_performance() {
		return tb_biz_performance;
	}

	public void setTb_biz_performance(TbbizPerformance tb_biz_performance) {
		this.tb_biz_performance = tb_biz_performance;
	}

	public TbempPerformance getTb_emp_performance() {
		return tb_emp_performance;
	}

	public void setTb_emp_performance(TbempPerformance tb_emp_performance) {
		this.tb_emp_performance = tb_emp_performance;
	}

	public TbservicePerformance getTb_service_performance() {
		return tb_service_performance;
	}

	public void setTb_service_performance(
			TbservicePerformance tb_service_performance) {
		this.tb_service_performance = tb_service_performance;
	}

	public BcustomerCount getB_customer_count() {
		return b_customer_count;
	}

	public void setB_customer_count(BcustomerCount b_customer_count) {
		this.b_customer_count = b_customer_count;
	}

	public IncomePerformance getTb_income_performance() {
		return tb_income_performance;
	}

	public void setTb_income_performance(IncomePerformance tb_income_performance) {
		this.tb_income_performance = tb_income_performance;
	}
	 
	 

}
