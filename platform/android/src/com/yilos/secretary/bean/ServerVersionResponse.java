package com.yilos.secretary.bean;

/**
 * 
 * 版本判断结果解析
 *
 */
public class ServerVersionResponse 
{

	 private int code;
	 
	 private VersionReqResult result;
	 
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


	public VersionReqResult getResult() {
		return result;
	}

	public void setResult(VersionReqResult result) {
		this.result = result;
	}

}
