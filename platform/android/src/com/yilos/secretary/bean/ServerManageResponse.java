package com.yilos.secretary.bean;

public class ServerManageResponse 
{
    private int code;
	
	private  ManageResult result;
	
	public boolean isSucess()
	{
		return code==0;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public ManageResult getResult() {
		return result;
	}

	public void setResult(ManageResult result) {
		this.result = result;
	}
	
	
}
