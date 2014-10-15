package com.yilos.secretary.bean;

public class ManageResult 
{
	private  ManageRecords  current;
	
	private  ManageRecords  prev;
	
	private  String last_backupDate;
	
	private String errorCode;

	

	public ManageRecords getCurrent() {
		return current;
	}

	public void setCurrent(ManageRecords current) {
		this.current = current;
	}

	public ManageRecords getPrev() {
		return prev;
	}

	public void setPrev(ManageRecords prev) {
		this.prev = prev;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getLast_backupDate() {
		return last_backupDate;
	}

	public void setLast_backupDate(String last_backupDate) {
		this.last_backupDate = last_backupDate;
	}
	
	
}
