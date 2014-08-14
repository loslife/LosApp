package com.yilos.secretary.bean;

import java.io.Serializable;

public class MemberBean  implements Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -23224764617311794L;

	private String id;
	
    private String name;
    
    private String enterprise_id;

    private String create_date;
    
    private String modify_date;
    
    private String latestConsumeTime;
    
    private String birthday;
    
    private String totalConsume;
    
    private String memberNo;
    
    private String joinDate;
    
    private String phoneMobile;
    
    private String averageConsume;
    
    private String cardStr;
    
    private String sex;
    
    private String entity_id;
    
    
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

	public String getModify_date() {
		return modify_date;
	}

	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getEnterprise_id() {
		return enterprise_id;
	}

	public void setEnterprise_id(String enterprise_id) {
		this.enterprise_id = enterprise_id;
	}

	public String getLatestConsumeTime() {
		return latestConsumeTime;
	}

	public void setLatestConsumeTime(String latestConsumeTime) {
		this.latestConsumeTime = latestConsumeTime;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getTotalConsume() {
		return totalConsume;
	}

	public void setTotalConsume(String totalConsume) {
		this.totalConsume = totalConsume;
	}

	public String getMemberNo() {
		return memberNo;
	}

	public void setMemberNo(String memberNo) {
		this.memberNo = memberNo;
	}

	public String getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(String joinDate) {
		this.joinDate = joinDate;
	}

	public String getPhoneMobile() {
		return phoneMobile;
	}

	public void setPhoneMobile(String phoneMobile) {
		this.phoneMobile = phoneMobile;
	}

	public String getAverageConsume() {
		return averageConsume;
	}

	public void setAverageConsume(String averageConsume) {
		this.averageConsume = averageConsume;
	}

	public String getCardStr() {
		return cardStr;
	}

	public void setCardStr(String cardStr) {
		this.cardStr = cardStr;
	}

	public String getEntity_id() {
		return entity_id;
	}

	public void setEntity_id(String entity_id) {
		this.entity_id = entity_id;
	}

	
}
