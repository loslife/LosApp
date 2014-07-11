package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.bean.ServicePerformanceBean;

public class ServicePerformanceDBManager 
{

	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
    private String  shopId;
    
   
	public ServicePerformanceDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
        this.context = context;
    }  
    
    
	//id integer primary key autoincrement, enterprise_id varchar(64), total REAL, project_id varchar(64),
	//project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL,
    //modify_date REAL, year integer, month integer, day integer);";
	
    public void add(List<ServicePerformanceBean> servicePerformanceBean,String tableName)
    {
    	db.beginTransaction();
    	try
    	{
    		for(ServicePerformanceBean bean:servicePerformanceBean)
    		{
    			db.execSQL("INSERT INTO "+tableName+" VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
    				    new Object[]{bean.get_id(),
    					shopId,
    					bean.getTotal(),
    					bean.getProject_id(),
    					bean.getProject_name(),
    					bean.getProject_cateName(),
    					bean.getProject_cateId(),
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
    	finally
    	{
    		db.endTransaction();
    	}
    	
    	
    }
    
    public void update(ServicePerformanceBean employee,String tableName) 
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
    	cv.put("id", employee.get_id());
    	cv.put("enterprise_id", employee.getEnterprise_id());
    	cv.put("total", employee.getTotal());
    	cv.put("project_id", employee.getTotal());
    	cv.put("project_name", employee.getTotal());
    	cv.put("project_cateName", employee.getTotal());
    	cv.put("project_cateId", employee.getTotal());
    	cv.put("create_date", employee.getCreate_date());
    	cv.put("modify_date", employee.getModify_date());
    	cv.put("year", employee.getYear());
    	cv.put("month", employee.getMonth());
    	cv.put("day", employee.getDay());

    	db.update(tableName, cv, "id = ?", new String[]{employee.get_id()});  
    }
    
    public Cursor  queryByrecordId(String recordId,String tableName)
    {
    	Cursor c = db.rawQuery("SELECT * FROM "+tableName+" Where _id = ?", new String[]{recordId});  
		return c;
    }
    
    public List<ServicePerformanceBean> queryListBydate (String year,String month,String day,String type,String tableName)
    {
    	ArrayList<ServicePerformanceBean> list = new ArrayList<ServicePerformanceBean>();
    	Cursor c = queryBydate( year, month, day, type, tableName);
    	while(c.moveToNext())
    	{
    		ServicePerformanceBean bean = new  ServicePerformanceBean();
    		
    		bean.set_id(c.getString(c.getColumnIndex("id")));
        	bean.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	bean.setTotal(c.getString(c.getColumnIndex("total")));

        	bean.setProject_id(c.getString(c.getColumnIndex("project_id")));
        	bean.setProject_cateName(c.getString(c.getColumnIndex("project_cateName")));
        	bean.setProject_name(c.getString(c.getColumnIndex("project_name")));
        	bean.setProject_cateId(c.getString(c.getColumnIndex("project_cateId")));
        	
        	bean.setCreate_date(c.getString(c.getColumnIndex("create_date")));
        	bean.setModify_date(c.getString(c.getColumnIndex("modify_date")));
        	bean.setYear(c.getString(c.getColumnIndex("year")));
        	bean.setMonth(c.getString(c.getColumnIndex("month")));
        	bean.setDay(c.getString(c.getColumnIndex("day")));
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
