package com.yilos.losapp.bean;


/**
 * 
 * 产品业绩
 *
 */
public class ServicePerformanceBean 
{

	//"enterprise_id":"100048101900800200","total":1300,"project_id":"100048101900800200-8660f540-e6e4-11e3-a12b-a3472b85461a",
	//"project_name":"套盒","project_cateName":"卖品","project_cateId":"100048101900800200-29cbe5c0-e6e3-11e3-a12b-a3472b85461a",
	//"week":0,"create_date":1403570273174,"syncindex":0,"synctag":0,"status":0,"year":2014,"month":5,"day":22,"_id":"53bb890066daed530600013d"
	
	private String _id;
	
	private String enterprise_id;
	
	private String total;
	
	private String project_id;
	
	private String project_name;
	
	private String project_cateName;
	
	private String project_cateId;
	
	private String week;
	
	private String create_date;
	
	private String modify_date;
	
	private String year;
	
	private String month;
	
	private String day;
	
	

	public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}

	public String getEnterprise_id() {
		return enterprise_id;
	}

	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getProject_id() {
		return project_id;
	}

	public void setProject_id(String project_id) {
		this.project_id = project_id;
	}

	public String getProject_name() {
		return project_name;
	}

	public void setProject_name(String project_name) {
		this.project_name = project_name;
	}

	public String getProject_cateName() {
		return project_cateName;
	}

	public void setProject_cateName(String project_cateName) {
		this.project_cateName = project_cateName;
	}

	public String getProject_cateId() {
		return project_cateId;
	}

	public void setProject_cateId(String project_cateId) {
		this.project_cateId = project_cateId;
	}

	public String getWeek() {
		return week;
	}

	public void setWeek(String week) {
		this.week = week;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	public String getModify_date() {
		return modify_date;
	}

	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	
	
}
