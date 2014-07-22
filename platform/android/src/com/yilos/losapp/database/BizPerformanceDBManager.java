package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.bean.BizPerformanceBean;
import com.yilos.losapp.bean.ServicePerformanceBean;

public class BizPerformanceDBManager 
{
	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
    private String  shopId;
    
   
	public BizPerformanceDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
        this.context = context;
    }  
    
    
	//biz_performance_month (id integer primary key autoincrement, enterprise_id varchar(64), 
	//total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, 
	//recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
	
    public void add(BizPerformanceBean bean,String tableName)
    {
    	db.beginTransaction();
    	try
    	{
              if(null!=bean.get_id())
              {
            	  db.execSQL("INSERT INTO "+tableName+" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
      				    new Object[]{bean.get_id(),
      					shopId,
      					bean.getTotal(),
      					bean.getCash(),
      					bean.getCard(),
      					bean.getBank(),
      					bean.getService(),
      					bean.getProduct(),
      					bean.getNewcard(),
      					bean.getRecharge(),
      					bean.getCreate_date(),
      					bean.getModify_date(),
      					bean.getYear(),
      					bean.getMonth(),
      					bean.getDay()
      		            }
      				);
              }
    		db.setTransactionSuccessful();  //设置事务成功完成  
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}
    	finally
    	{
    		db.endTransaction();
    	}
    	
    	
    }
    
    public void update(BizPerformanceBean bean,String tableName) 
    {
    	
    	/**
    	 * bean.getEnterprise_id(),
    					bean.getTotal(),
    					bean.getCash(),
    					bean.getCard(),
    					bean.getBank(),
    					bean.getService(),
    					bean.getProduct(),
    					bean.getNewcard(),
    					bean.getRecharge(),
    					bean.getCreate_date(),
    					bean.getModify_date(),
    					bean.getEmployee_name(),
    					bean.getYear(),
    					bean.getMonth(),
    					bean.getDay(),
    					bean.getWeek()
    	 */
    	//id integer primary key autoincrement, enterprise_id varchar(64), total REAL, project_id varchar(64),
    	//project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL,
        //modify_date REAL, year integer, month integer, day integer);";
    	ContentValues cv = new ContentValues();
    	cv.put("id", bean.get_id());
    	cv.put("enterprise_id", bean.getEnterprise_id());
    	cv.put("total", bean.getTotal());
    
    	cv.put("cash", bean.getCash());
    	cv.put("card", bean.getCard());
    	cv.put("bank", bean.getBank());
    	cv.put("service", bean.getService());
    	cv.put("product", bean.getProduct());
    	cv.put("newcard", bean.getNewcard());
    	cv.put("recharge", bean.getRecharge());
    	cv.put("create_date", bean.getCreate_date());
    	cv.put("modify_date", bean.getModify_date());
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
    
    public List<BizPerformanceBean> queryListBydate (String year,String month,String day,String type,String tableName)
    {
    	ArrayList<BizPerformanceBean> list = new ArrayList<BizPerformanceBean>();
    	Cursor c = queryBydate( year, month, day, type, tableName);
    	while(c.moveToNext())
    	{
    		BizPerformanceBean bean = new  BizPerformanceBean();
    		
    		bean.set_id(c.getString(c.getColumnIndex("id")));
        	bean.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	bean.setTotal(c.getString(c.getColumnIndex("total")));

        	bean.setCash(c.getString(c.getColumnIndex("cash")));
        	bean.setCard(c.getString(c.getColumnIndex("card")));
        	bean.setBank(c.getString(c.getColumnIndex("bank")));
        	bean.setService(c.getString(c.getColumnIndex("service")));
        	bean.setProduct(c.getString(c.getColumnIndex("product")));
        	bean.setNewcard(c.getString(c.getColumnIndex("newcard")));
        	bean.setRecharge(c.getString(c.getColumnIndex("recharge")));
        	
        	bean.setCreate_date(c.getString(c.getColumnIndex("create_date")));
        	bean.setModify_date(c.getString(c.getColumnIndex("modify_date")));
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



}
