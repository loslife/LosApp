package com.yilos.losapp.bean;

/**
 * 
 * 客流量
 *
 */
public class BcustomerCountBean 
{

	//enterprise_id":"100051602194600110","member":0,"temp":1,"create_date":1404809340264,"syncindex":0,
	//"synctag":0,"status":0,"year":2014,"month":6,"day":8,"hour":16,"_id":"53bbb32699d64ed49e000241"
	
	private String _id;
	
	private String enterprise_id;
	
	private String member;
	
	private String temp;
	
	private String dateTime;
	
	private String year;
	
	private String month;
	
	private String day;
	
	private int hour;

	public String getEnterprise_id() {
		return enterprise_id;
	}

	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}

	public String getMember() {
		return member;
	}

	public void setMember(String member) {
		this.member = member;
	}

	public String getTemp() {
		return temp;
	}

	public void setTemp(String temp) {
		this.temp = temp;
	}

	public String getDateTime() {
		return dateTime;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
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

	public int getHour() {
		return hour;
	}

	public void setHour(int hour) {
		this.hour = hour;
	}

	public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}
	
	
}
