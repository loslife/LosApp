package com.yilos.losapp.bean;


public class Result
{

	private  long  last_sync;
	
	private String enterprise_name;
	
	private String enterprise_id;
	
	private  Records  records;

	public long getLast_sync() {
		return last_sync;
	}


	public void setLast_sync(long last_sync) {
		this.last_sync = last_sync;
	}


	public Records getRecords() {
		return records;
	}


	public void setRecords(Records records) {
		this.records = records;
	}


	public String getEnterprise_name() {
		return enterprise_name;
	}


	public void setEnterprise_name(String enterprise_name) {
		this.enterprise_name = enterprise_name;
	}


	public String getEnterprise_id() {
		return enterprise_id;
	}


	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}
    
	
    
}
