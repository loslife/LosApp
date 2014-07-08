package com.yilos.losapp.bean;


/**
 * 
 * 经营业绩
 *
 */
public class BizPerformanceBean 
{
	//"enterprise_id":"100051602194600110","total":64,"cash":60,"bank":0,
	//"card":4,"newcard":0,"recharge":0,"service":64,"product":0,"week":0,"create_date":1404809340264,
	//"syncindex":0,"synctag":0,"status":0,"year":2014,"month":6,"day":8,"_id":"53bbcc39e488d31cb7000028"
	
	private String enterprise_id;
	
	private String total;
	private String cash;
	private String bank;
	private String card;
	private String newcard;
	private String recharge;
	
	private String service;
	private String product;
	private String week;
	private String create_date;
	private String year;
	private String month;
	private String day;
	
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
	public String getCash() {
		return cash;
	}
	public void setCash(String cash) {
		this.cash = cash;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public String getCard() {
		return card;
	}
	public void setCard(String card) {
		this.card = card;
	}
	public String getNewcard() {
		return newcard;
	}
	public void setNewcard(String newcard) {
		this.newcard = newcard;
	}
	public String getRecharge() {
		return recharge;
	}
	public void setRecharge(String recharge) {
		this.recharge = recharge;
	}
	public String getService() {
		return service;
	}
	public void setService(String service) {
		this.service = service;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
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
	
	
}
