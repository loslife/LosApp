package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.bean.BcustomerCountBean;

public class CustomerCountDBManager 
{

	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
    private String  shopId;
    
   
	public CustomerCountDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
        this.context = context;
    }  
    
    
    //id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, 
	//member integer, year integer, month integer, day integer, hour integer, create_date REAL);";
    public void add(List<BcustomerCountBean> customerCountList,String tableName)
    {
    	db.beginTransaction();
    	try
    	{
    		for(BcustomerCountBean bean:customerCountList)
    		{
    			if(null!= bean.get_id())
    			{
    			db.execSQL("INSERT INTO "+tableName+" VALUES(?,?,?,?,?,?,?,?,?)",
    				    new Object[]{bean.get_id(),
    					shopId,
    					bean.getTemp(),
    					bean.getMember(),
    					bean.getYear(),
    					bean.getMonth(),
    					bean.getDay(),
    					bean.getHour(),
    					bean.getDateTime()
    		            }
    				);
    			}
    		}
    		db.setTransactionSuccessful();  //设置事务成功完成  
    	}
    	finally
    	{
    		db.endTransaction();
    	}
    	
    	
    }
    
    public void update(BcustomerCountBean bean,String tableName) 
    {
    	//id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, 
    	//member integer, year integer, month integer, day integer, hour integer, create_date REAL);";
    	ContentValues cv = new ContentValues();
    	cv.put("id", bean.get_id());
    	cv.put("walkin", bean.getEnterprise_id());
    	cv.put("enterprise_id", bean.getTemp());
    	cv.put("member", bean.getMember());
    	cv.put("dateTime", bean.getDateTime());
    	cv.put("hour", bean.getHour());
    	cv.put("year", bean.getYear());
    	cv.put("month", bean.getMonth());
    	cv.put("day", bean.getDay());

    	db.update(tableName, cv, "id = ?", new String[]{bean.get_id()});  
    }
    
    public Cursor  queryByrecordId(String recordId,String tableName)
    {
    	Cursor c = db.rawQuery("SELECT * FROM "+tableName+" Where _id = ?", new String[]{recordId});  
		return c;
    }
    
    public List<BcustomerCountBean> queryListBydate (String year,String month,String day,String type,String tableName)
    {
    	ArrayList<BcustomerCountBean> list = new ArrayList<BcustomerCountBean>();
    	Cursor c = queryBydate( year, month, day, type, tableName);
    	while(c.moveToNext())
    	{
    		BcustomerCountBean bean = new  BcustomerCountBean();
    		
    		bean.set_id(c.getString(c.getColumnIndex("_id")));
        	bean.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	bean.setMember(c.getString(c.getColumnIndex("member")));
        	bean.setTemp(c.getString(c.getColumnIndex("walkin")));
        	bean.setHour(c.getString(c.getColumnIndex("hour")));
        	bean.setDateTime(c.getString(c.getColumnIndex("dateTime")));
        	bean.setYear(c.getString(c.getColumnIndex("year")));
        	bean.setMonth(c.getString(c.getColumnIndex("month")));
        	bean.setDay(c.getString(c.getColumnIndex("day")));
        	list.add(bean);
    	}
    	c.close();
    	return list;
    }
    
    public void deleteBydate(String year,String month,String day,String type,String tableName)
    {
    	String sql = "";
    	String[] selectionArgs = null ;
    	
    	if(!"month".equals(type))
    	{
    		sql = "year = ? and month = ? and day = ? and enterprise_id = ?";
    		selectionArgs = new String[]{ year, month, day,shopId};
    	}
    	else 
    	{
    		sql = "year = ? and month = ? and enterprise_id = ?";
    		selectionArgs = new String[]{ year, month,shopId};
    	}
    	db.beginTransaction();
    	db.delete(tableName, sql, selectionArgs);
    	db.setTransactionSuccessful();
    	db.endTransaction();
    }
    
    public Cursor  queryBydate(String year,String month,String day,String type,String tableName)
    {
    	String sql = "";
    	String[] selectionArgs = null ;
    	
    	if(!"month".equals(type))
    	{
    		sql = "SELECT * FROM "+tableName+" Where year = ? and month = ? and day = ? and enterprise_id = ?";
    		selectionArgs = new String[]{ year, month, day,shopId};
    	}
    	else 
    	{
    		sql = "SELECT * FROM "+tableName+" Where year = ? and month = ? and enterprise_id = ?";
    		selectionArgs = new String[]{ year, month,shopId};
    	}
    	
    	Cursor c = db.rawQuery(sql, selectionArgs);  
		return c;
    }
	/**
	 * {
    "code": 0, 
    "result": {
        "current": {
            "b_customer_count": {
                "day": {
                    "enterprise_id": "100048101900800200", 
                    "member": 12, 
                    "temp": 3, 
                    "create_date": 1401247895764, 
                    "syncindex": 0, 
                    "synctag": 0, 
                    "status": 0, 
                    "year": 2014, 
                    "month": 4, 
                    "day": 28, 
                    "hour": 11, 
                    "_id": "53bc9d6ea8fca1167c00029c"
                }, 
                "hours": [
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    {
                        "enterprise_id": "100048101900800200", 
                        "member": 2, 
                        "temp": 0, 
                        "create_date": 1401247895764, 
                        "syncindex": 0, 
                        "synctag": 0, 
                        "status": 0, 
                        "year": 2014, 
                        "month": 4, 
                        "day": 28, 
                        "hour": 11, 
                        "_id": "53bc9d6ea8fca1167c000285"
                    }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    {
                        "enterprise_id": "100048101900800200", 
                        "member": 4, 
                        "temp": 2, 
                        "create_date": 1401270502272, 
                        "syncindex": 0, 
                        "synctag": 0, 
                        "status": 0, 
                        "year": 2014, 
                        "month": 4, 
                        "day": 28, 
                        "hour": 17, 
                        "_id": "53bc9d6ea8fca1167c000286"
                    }, 
                    {
                        "enterprise_id": "100048101900800200", 
                        "member": 6, 
                        "temp": 1, 
                        "create_date": 1401271217542, 
                        "syncindex": 0, 
                        "synctag": 0, 
                        "status": 0, 
                        "year": 2014, 
                        "month": 4, 
                        "day": 28, 
                        "hour": 18, 
                        "_id": "53bc9d6ea8fca1167c000287"
                    }, 
                    { }, 
                    { }, 
                    { }, 
                    { }
                ]
            }
        }, 
        "prev": {
            "b_customer_count": {
                "day": { }, 
                "hours": [
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }, 
                    { }
                ]
            }
        }
    }
}
	 */
}
