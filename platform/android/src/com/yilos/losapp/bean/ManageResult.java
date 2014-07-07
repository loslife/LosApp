package com.yilos.losapp.bean;

public class ManageResult 
{
	private  ManageRecords  records;
	
	private String errorCode;

	public ManageRecords getRecords() {
		return records;
	}

	public void setRecords(ManageRecords records) {
		this.records = records;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	
	
}
