package com.yilos.losapp.bean;


public class ServerResponse
{

	private int code;
	
	private  Result result;
	
	public boolean isSucess()
	{
		return code==0;
	}

	public Result getResult() {
		return result;
	}

	public void setResult(Result result) {
		this.result = result;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	@Override
	public String toString() {
		return "ServerResponse [code=" + code + ", result=" + result + "]";
	}

	
}
