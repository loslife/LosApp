package com.yilos.losapp.database;

import java.util.List;

import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MemberBean;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

public class EmployeePerDBManager 
{
	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
      
    public EmployeePerDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        
        this.context = context;
    }  
    
    
    //id varchar(64) NOT NULL primary key, enterprise_id varchar(64), 
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
    			db.execSQL("INSERT INTO "+tableName+" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?",
    				    new Object[]{bean.getEnterprise_id(),
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
    		            }
    				);
    		}
    	}
    	finally
    	{
    		db.endTransaction();
    	}
    	
    	db.setTransactionSuccessful();  //设置事务成功完成  
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
        //employee_name varchar(16), year integer, month integer, day integer, week integer
    	ContentValues cv = new ContentValues();
    	cv.put("id", employee.getId());
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
    	cv.put("week", employee.getWeek());
    	db.update(tableName, cv, "id = ?", new String[]{employee.getId()});  
    }
    
    public List<EmployeePerBean>  query()
    {
		return null;
    }
}
