package com.yilos.losapp.bean;


public class Result
{

	private  long  last_sync;
	
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
    
    
}
