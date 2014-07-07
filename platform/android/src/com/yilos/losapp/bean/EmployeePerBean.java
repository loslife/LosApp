package com.yilos.losapp.bean;

public class EmployeePerBean 
{
	
/**
 *   id varchar(64) NOT NULL primary key,
 *   enterprise_id varchar(64), total REAL,
 *   cash REAL, card REAL, bank REAL, service REAL, 
 *   product REAL, newcard REAL, recharge REAL, 
 *   create_date REAL, modify_date REAL, 
 *   type integer, employee_name varchar(16), 
 *   year integer, month integer, day integer, week integer
 */
	 String  id;
     String  create_date ;
     String  enterprise_id;
     String  modify_date;
     String  product;
     String  employee_name;
     String  total;
     String  day;
     String  recharge;
     String  cash;
     String  newcard ;
     String  card;
     String  service; 
     String  bank ;
     String  year ;
     String  month; 
     String  week ;
     
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getEnterprise_id() {
		return enterprise_id;
	}
	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getEmployee_name() {
		return employee_name;
	}
	public void setEmployee_name(String employee_name) {
		this.employee_name = employee_name;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getRecharge() {
		return recharge;
	}
	public void setRecharge(String recharge) {
		this.recharge = recharge;
	}
	
	public String getCash() {
		return cash;
	}
	public void setCash(String cash) {
		this.cash = cash;
	}
	public String getNewcard() {
		return newcard;
	}
	public void setNewcard(String newcard) {
		this.newcard = newcard;
	}
	public String getCard() {
		return card;
	}
	public void setCard(String card) {
		this.card = card;
	}
	public String getService() {
		return service;
	}
	public void setService(String service) {
		this.service = service;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
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
	public String getWeek() {
		return week;
	}
	public void setWeek(String week) {
		this.week = week;
	}

}
