package com.yilos.losapp.bean;

import java.util.ArrayList;
import java.util.List;

public class Records {
	
	private List<MemberBean> add = new ArrayList<MemberBean>();
	
	private List<MemberBean> update = new ArrayList<MemberBean>();
	
	private List<MemberBean> remove = new ArrayList<MemberBean>();

	public List<MemberBean> getAdd() {
		return add;
	}

	public void setAdd(List<MemberBean> add) {
		this.add = add;
	}

	public List<MemberBean> getUpdate() {
		return update;
	}

	public void setUpdate(List<MemberBean> update) {
		this.update = update;
	}

	public List<MemberBean> getRemove() {
		return remove;
	}

	public void setRemove(List<MemberBean> remove) {
		this.remove = remove;
	}
	
}
