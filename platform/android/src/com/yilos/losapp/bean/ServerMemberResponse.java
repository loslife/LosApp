package com.yilos.losapp.bean;


public class ServerMemberResponse
{

	private int code;
	
	private  ContactsResult result;
	
	public boolean isSucess()
	{
		return code==0;
	}

	public ContactsResult getResult() {
		return result;
	}

	public void setResult(ContactsResult result) {
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
