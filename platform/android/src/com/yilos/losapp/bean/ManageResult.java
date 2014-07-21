package com.yilos.losapp.bean;

public class ManageResult 
{
	private  ManageRecords  current;
	
	private  ManageRecords  prev;
	
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
	
	
}
