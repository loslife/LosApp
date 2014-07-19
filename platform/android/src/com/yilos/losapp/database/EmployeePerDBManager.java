package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MemberBean;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class EmployeePerDBManager 
{
	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
    private String  shopId;
    
   
	public EmployeePerDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
        this.context = context;
    }  
    
    
    //id varchar(64) NOT NULL primary key, record_id varchar(64), enterprise_id varchar(64), 
    //total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, 
    //newcard REAL, recharge REAL, create_date REAL, modify_date REAL, 
    //employee_name varchar(16), year integer, month integer, day integer, week integer
    public void add(List<EmployeePerBean> employeePerBean,String tableName)
    {
    	db.beginTransaction();
    	try
    	{
    		for(EmployeePerBean bean:employeePerBean)
    		{
    			if(null!=bean.get_id())
                {
	    			db.execSQL("INSERT INTO "+tableName+" VALUES(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
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
	    					bean.getEmployee_name(),
	    					bean.getYear(),
	    					bean.getMonth(),
	    					bean.getDay()
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
    
    public void update(EmployeePerBean employee,String tableName) 
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
    	 //id varchar(64) NOT NULL primary key, enterprise_id varchar(64), 
        //total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, 
        //newcard REAL, recharge REAL, create_date REAL, modify_date REAL, 
        //employee_name varchar(16), year integer, month integer, day integer, 
    	ContentValues cv = new ContentValues();
    	cv.put("id", employee.getId());
    	cv.put("record_id", employee.get_id());
    	cv.put("enterprise_id", employee.getEnterprise_id());
    	cv.put("employee_name", employee.getEmployee_name());
    	cv.put("employee_id", employee.getEmployee_id());
    	cv.put("total", employee.getTotal());
    	cv.put("cash", employee.getCash());
    	cv.put("card", employee.getCard());
    	cv.put("bank", employee.getBank());
    	cv.put("service", employee.getService());
    	cv.put("product", employee.getProduct());
    	cv.put("newcard", employee.getNewcard());
    	cv.put("recharge", employee.getRecharge());
    	cv.put("create_date", employee.getCreate_date());
    	cv.put("modify_date", employee.getModify_date());
    	cv.put("year", employee.getYear());
    	cv.put("month", employee.getMonth());
    	cv.put("day", employee.getDay());

    	db.update(tableName, cv, "id = ?", new String[]{employee.getId()});  
    }
    
    public Cursor  queryByrecordId(String recordId,String tableName)
    {
    	Cursor c = db.rawQuery("SELECT * FROM "+tableName+" Where _id = ?", new String[]{recordId});  
		return c;
    }
    
    public List<EmployeePerBean> queryListBydate (String year,String month,String day,String type,String tableName)
    {
    	ArrayList<EmployeePerBean> list = new ArrayList<EmployeePerBean>();
    	Cursor c = queryBydate( year, month, day, type, tableName);
    	while(c.moveToNext())
    	{
    		EmployeePerBean bean = new  EmployeePerBean();
    		
    		bean.setId(c.getString(c.getColumnIndex("id")));
        	bean.set_id(c.getString(c.getColumnIndex("record_id")));
        	bean.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	bean.setEmployee_name(c.getString(c.getColumnIndex("employee_name")));
        	bean.setEmployee_id(c.getString(c.getColumnIndex("employee_name")));
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
