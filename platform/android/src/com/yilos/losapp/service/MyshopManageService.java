package com.yilos.losapp.service;

import java.util.List;

import android.content.Context;

import com.yilos.losapp.bean.MyShopBean;
import com.yilos.losapp.database.MyShopDBManager;

public class MyshopManageService {
	
	private MyShopDBManager myShopDB;

	public MyshopManageService(Context context) {
		myShopDB = new MyShopDBManager(context);
	}
	
	public void addShops(List<MyShopBean> shops)
	{
		for(MyShopBean shop:shops)
		{
			myShopDB.add(shop);
		}
	}
	
	public void addShop(MyShopBean shop)
	{
		myShopDB.add(shop);
	}
	
	public void updateShops(MyShopBean shop)
	{ 
		myShopDB.update(shop);
	}
	
	public void updateLatestSync(String latestSync,String shopId,String SyncType)
	{ 
		if(SyncType == "Contacts")
		{
			myShopDB.updateContactLatestSync(shopId, latestSync);
		}
		
		if(SyncType == "reports")
		{
			myShopDB.updateReportLatestSync(shopId, latestSync);
		}
	}
	
	public List<MyShopBean> queryShops()
	{
		return myShopDB.query();
	}


}