package com.yilos.secretary.bean;

public class MyShopBean {

	private int id;
	
	private String enterprise_id;
	
	private String enterprise_name;
	
	private String latest_sync;
	
	private String contactSyncTime;
	
	private String reportSyncTime;
	
	private String display;
	
	private String create_date;
	
	private String enterprise_account;
	
	private int order;

	public String getEnterprise_id() {
		return enterprise_id;
	}

	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}

	public String getEnterprise_name() {
		return enterprise_name;
	}

	public void setEnterprise_name(String enterprise_name) {
		this.enterprise_name = enterprise_name;
	}

	public String getLatest_sync() {
		return latest_sync;
	}

	public void setLatest_sync(String latest_sync) {
		this.latest_sync = latest_sync;
	}

	public String getDisplay() {
		return display;
	}

	public void setDisplay(String display) {
		this.display = display;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	
	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getContactSyncTime() {
		return contactSyncTime;
	}

	public void setContactSyncTime(String contactSyncTime) {
		this.contactSyncTime = contactSyncTime;
	}

	public String getReportSyncTime() {
		return reportSyncTime;
	}

	public void setReportSyncTime(String reportSyncTime) {
		this.reportSyncTime = reportSyncTime;
	}

	public String getEnterprise_account() {
		return enterprise_account;
	}

	public void setEnterprise_account(String enterprise_account) {
		this.enterprise_account = enterprise_account;
	}
	
	
}