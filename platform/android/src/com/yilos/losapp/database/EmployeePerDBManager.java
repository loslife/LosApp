package com.yilos.losapp.database;

import java.util.List;

import com.yilos.losapp.bean.EmployeePerBean;
import com.yilos.losapp.bean.MemberBean;

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
    
    public void add(List<EmployeePerBean> employeePerBean,String tableName)
    {
    	
    }
    
    public void update(EmployeePerBean employee) 
    {
    	
    }
    
    public List<EmployeePerBean>  query()
    {
		return null;
    	
    }
}
