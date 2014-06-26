package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yilos.losapp.bean.MyShopBean;

public class MyShopDBManager {
	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
      
    public MyShopDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        db = helper.getWritableDatabase();  
    }  
      
    /** 
     * add member 
     * @param member 
     */  
    public void add(MyShopBean shop) { 
    	//enterprise_id varchar(64), enterprise_name varchar(64), contact_latest_sync REAL, report_latest_sync REAL, display varchar(8), create_date REAL
        db.beginTransaction();  //开始事务  
        try {  
                db.execSQL("INSERT INTO t_myshops VALUES(null,?,?,?,?,?,?,?)", 
                		new Object[]{shop.getEnterprise_id(), shop.getEnterprise_name(),shop.getLatest_sync(), shop.getLatest_sync(),
                		             shop.isDisplay(),shop.getCreate_date(),shop.getOrder()});  
             
            db.setTransactionSuccessful();  //设置事务成功完成  
        } finally {  
            db.endTransaction();    //结束事务  
        }  
    }  
      
    /** 
     * update report_latest_sync
     * @param  
     */  
    public void updateReportLatestSync(String shopId,String latestTime) {  

        db.execSQL("update t_myshops set report_latest_sync=? where enterprise_id=?", new String[]{latestTime,shopId});
    } 
    
    /** 
     * update contact_latest_sync
     * @param  
     */  
    public void updateContactLatestSync(String shopId,String latestTime) {  

        db.execSQL("update t_myshops set contact_latest_sync=? where enterprise_id=?", new String[]{latestTime,shopId});
    }
    
    /** 
     * update
     * @param person 
     */  
    public void update(MyShopBean shop) {  
        ContentValues cv = new ContentValues();  
        cv.put("id", shop.getId()); 
        cv.put("enterprise_name", shop.getEnterprise_name()); 
        cv.put("enterprise_id", shop.getEnterprise_id()); 
        cv.put("create_date", shop.getCreate_date());
        cv.put("display", shop.isDisplay()); 
        db.update("t_myshops", cv, "id = ?", new String[]{String.valueOf(shop.getId())});  
    }  
      
    /** 
     * delete
     * @param person 
     */  
    public void delete(MyShopBean shop) {  
        db.delete("t_myshops", "id = ?", new String[]{String.valueOf(shop.getId())});  
    }  
      
    /** 
     * query all persons
     * @return List<MemberBean> 
     */  
    public List<MyShopBean> query() {  
        ArrayList<MyShopBean> shops = new ArrayList<MyShopBean>();  
        Cursor c = queryRecords();  
        while (c.moveToNext()) {  
        	
        	MyShopBean shop = new MyShopBean();  
        	shop.setId(c.getInt(c.getColumnIndex("id")));  
        	shop.setEnterprise_name(c.getString(c.getColumnIndex("enterprise_name")));  
        	shop.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	shop.setCreate_date(c.getString(c.getColumnIndex("create_date")));
        	shop.setOrder(c.getInt(c.getColumnIndex("order_number")));
        	shops.add(shop);  
        }  
        c.close();  
        return shops;  
    }  
      
    /** 
     * query member
     * @return  Cursor 
     */  
    public Cursor queryRecords() {  
        Cursor c = db.rawQuery("SELECT * FROM t_myshops ", null);  
        return c;  
    }  
      
    /** 
     * close database 
     */  
    public void closeDB() {  
        db.close();  
    }  
}
