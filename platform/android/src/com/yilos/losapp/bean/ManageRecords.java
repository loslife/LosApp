package com.yilos.losapp.bean;

import java.util.ArrayList;
import java.util.List;

public class ManageRecords 
{
	public TbbizPerformance tb_biz_performance;
	
	public TbempPerformance tb_emp_performance;
	
	public TbservicePerformance tb_service_performance;
	
	public BcustomerCount b_customer_count;
	
	 public static class TbservicePerformance {
		 
		    private List<TbservicePerformanceBean> day = new ArrayList<TbservicePerformanceBean>();
			
			private List<TbservicePerformanceBean> week = new ArrayList<TbservicePerformanceBean>();
			
			private List<TbservicePerformanceBean> month = new ArrayList<TbservicePerformanceBean>();

			public List<TbservicePerformanceBean> getDay() {
				return day;
			}

			public void setDay(List<TbservicePerformanceBean> day) {
				this.day = day;
			}

			public List<TbservicePerformanceBean> getWeek() {
				return week;
			}

			public void setWeek(List<TbservicePerformanceBean> week) {
				this.week = week;
			}

			public List<TbservicePerformanceBean> getMonth() {
				return month;
			}

			public void setMonth(List<TbservicePerformanceBean> month) {
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
		 
		    private List<BizPerformanceBean> day = new ArrayList<BizPerformanceBean>();
			
			private List<BizPerformanceBean> week = new ArrayList<BizPerformanceBean>();
			
			private List<BizPerformanceBean> month = new ArrayList<BizPerformanceBean>();

			public List<BizPerformanceBean> getDay() {
				return day;
			}

			public void setDay(List<BizPerformanceBean> day) {
				this.day = day;
			}

			public List<BizPerformanceBean> getWeek() {
				return week;
			}

			public void setWeek(List<BizPerformanceBean> week) {
				this.week = week;
			}

			public List<BizPerformanceBean> getMonth() {
				return month;
			}

			public void setMonth(List<BizPerformanceBean> month) {
				this.month = month;
			}

	 }
	 
	 public static class BcustomerCount {
		 
		    private List<BcustomerCountBean> day = new ArrayList<BcustomerCountBean>();
			
			private List<BcustomerCountBean> week = new ArrayList<BcustomerCountBean>();
			
			private List<BcustomerCountBean> month = new ArrayList<BcustomerCountBean>();

			public List<BcustomerCountBean> getDay() {
				return day;
			}

			public void setDay(List<BcustomerCountBean> day) {
				this.day = day;
			}

			public List<BcustomerCountBean> getWeek() {
				return week;
			}

			public void setWeek(List<BcustomerCountBean> week) {
				this.week = week;
			}

			public List<BcustomerCountBean> getMonth() {
				return month;
			}

			public void setMonth(List<BcustomerCountBean> month) {
				this.month = month;
			}
			
			
	 }

}
