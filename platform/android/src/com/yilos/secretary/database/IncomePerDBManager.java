package com.yilos.secretary.database;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.bean.IncomePerformanceBean;

public class IncomePerDBManager 
{

	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
    private String  shopId;
    
   
	public IncomePerDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
      
        this.context = context;
    }  
    
    /**
     * "CREATE TABLE IF NOT EXISTS income_performance_month(id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
	            +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
	            + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
	            + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
	            + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
	            + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";
     * @param bean
     * @param tableName
     */
    public void add(IncomePerformanceBean bean,String tableName)
    {
    	shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
    	db.beginTransaction();
    	try
    	{
              if(null!=bean.get_id())
              {
            	db.execSQL("INSERT INTO "+tableName+" VALUES(?,?,?,"
	            +"?,?,?,?,?,"
	            + "?,?,?,?,?,?,"
	            + "?,?,?,?,?,?,"
	            + "?,?,?,?,?,?,"
	            + "?,?)",
      				    new Object[]{bean.get_id(),
      					shopId,
      					bean.getTotal_income(),
      					bean.getTotal_prepay(),
      					bean.getTotal_paidin(),
      					bean.getTotal_paidin_bank(),
      					bean.getTotal_paidin_cash(),
      					bean.getService_cash(),
      					bean.getService_bank(),
      					bean.getProduct_cash(),
      					bean.getProduct_bank(),
      					bean.getCard(),
      					bean.getNewcard_cash(),
      					bean.getNewcard_bank(),
      					bean.getRechargecard_cash(),
      					bean.getRechargecard_bank(),
      					bean.getYear(),
      					bean.getMonth(),
      					bean.getDay(),
      					bean.getCreate_date(),
      					bean.getModify_date(),
      					bean.getSyncindex(),
      					bean.getSynctag(),
      					bean.getStatus(),
      					bean.getDef_str1(),
      					bean.getDef_int1(),
      					bean.getDef_int2(),
      					bean.getDef_int3()
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
    
    public void update(IncomePerformanceBean bean,String tableName) 
    {
    	/*"id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
        +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
        + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
        + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
        + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
        + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";*/
    	ContentValues cv = new ContentValues();
    	cv.put("id", bean.get_id());
    	cv.put("enterprise_id", bean.getEnterprise_id());
    	cv.put("total_income", bean.getTotal_income());
    	cv.put("total_prepay", bean.getTotal_prepay());
    	cv.put("total_paidin", bean.getTotal_paidin());
    	cv.put("total_paidin_bank", bean.getTotal_paidin_bank());
    	cv.put("total_paidin_cash", bean.getTotal_paidin_cash());
    	cv.put("service_cash", bean.getService_cash());
    	cv.put("service_bank", bean.getService_bank());
    	cv.put("product_cash", bean.getProduct_cash());
    	cv.put("product_bank", bean.getProduct_bank());
    	cv.put("card", bean.getCard());
    	cv.put("newcard_cash", bean.getNewcard_cash());
    	cv.put("newcard_bank", bean.getNewcard_bank());
    	cv.put("rechargecard_cash", bean.getRechargecard_cash());
    	cv.put("rechargecard_bank", bean.getRechargecard_bank());
    	cv.put("year", bean.getYear());
    	cv.put("month", bean.getMonth());
    	cv.put("day", bean.getDay());
    	cv.put("create_date", bean.getCreate_date());
    	cv.put("modify_date", bean.getModify_date());
    	cv.put("syncindex", bean.getSyncindex());
    	cv.put("synctag", bean.getSynctag());
    	cv.put("status", bean.getStatus());
    	cv.put("def_str1", bean.getDef_str1());
    	cv.put("def_int1", bean.getDef_int1());
    	cv.put("def_int2", bean.getDef_int2());
    	cv.put("def_int3", bean.getDef_int3());

    	db.update(tableName, cv, "id = ?", new String[]{bean.get_id()});  
    }
    
    public Cursor  queryByrecordId(String recordId,String tableName)
    {
    	Cursor c = db.rawQuery("SELECT * FROM "+tableName+" Where _id = ?", new String[]{recordId});  
		return c;
    }
    
    public List<IncomePerformanceBean> queryListBydate (String year,String month,String day,String type,String tableName)
    {
    	
    	ArrayList<IncomePerformanceBean> list = new ArrayList<IncomePerformanceBean>();
    	Cursor c = queryBydate( year, month, day, type, tableName);
    	while(c.moveToNext())
    	{
    		IncomePerformanceBean bean = new  IncomePerformanceBean();
    		
    		/*"id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
            +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
            + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
            + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
            + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
            + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";*/
    		bean.set_id(c.getString(c.getColumnIndex("id")));
        	bean.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
        	bean.setTotal_income(c.getString(c.getColumnIndex("total_income")));

        	bean.setTotal_prepay(c.getString(c.getColumnIndex("total_prepay")));
        	bean.setTotal_paidin(c.getString(c.getColumnIndex("total_paidin")));
        	bean.setTotal_paidin_bank(c.getString(c.getColumnIndex("total_paidin_bank")));
        	bean.setTotal_paidin_cash(c.getString(c.getColumnIndex("total_paidin_cash")));
        	bean.setService_cash(c.getString(c.getColumnIndex("service_cash")));
        	bean.setService_bank(c.getString(c.getColumnIndex("service_bank")));
        	bean.setProduct_cash(c.getString(c.getColumnIndex("product_cash")));
        	bean.setProduct_bank(c.getString(c.getColumnIndex("product_bank")));
        	bean.setCard(c.getString(c.getColumnIndex("card")));

        	bean.setNewcard_cash(c.getString(c.getColumnIndex("newcard_cash")));
        	bean.setNewcard_bank(c.getString(c.getColumnIndex("newcard_bank")));
        	bean.setRechargecard_cash(c.getString(c.getColumnIndex("rechargecard_cash")));
        	bean.setRechargecard_bank(c.getString(c.getColumnIndex("rechargecard_bank")));
        	bean.setYear(c.getInt(c.getColumnIndex("year"))+"");
        	bean.setMonth(c.getInt(c.getColumnIndex("month"))+"");
        	bean.setDay(c.getInt(c.getColumnIndex("day"))+"");
        	bean.setCreate_date(c.getString(c.getColumnIndex("create_date")));
        	bean.setModify_date(c.getString(c.getColumnIndex("modify_date")));
        	bean.setSyncindex(c.getString(c.getColumnIndex("syncindex")));
        	bean.setSynctag(c.getInt(c.getColumnIndex("synctag")));
        	bean.setStatus(c.getInt(c.getColumnIndex("status")));
        	bean.setDef_str1(c.getString(c.getColumnIndex("def_str1")));
        	bean.setDef_int1(c.getString(c.getColumnIndex("def_int1")));
        	bean.setDef_int2(c.getString(c.getColumnIndex("def_int2")));
        	bean.setDef_int3(c.getString(c.getColumnIndex("def_int3")));
        	
        	list.add(bean);
    	}
    	c.close();
    	return list;
    }
    
    public void deleteBydate(String year,String month,String day,String type,String tableName)
    {
    	String sql = "";
    	String[] selectionArgs = null ;
    	  shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
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
    	shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
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
    
    public int  queryAll(String tableName)
    {
    	shopId = AppContext.getInstance(context).getCurrentDisplayShopId();
    	String sql = "";
    	String[] selectionArgs = null ;
    	sql = "SELECT count(*) FROM "+tableName+" Where enterprise_id = ?";
    	selectionArgs = new String[]{shopId};
    	
    	Cursor c = db.rawQuery(sql, selectionArgs);  
    	c.moveToFirst();
        int icount = c.getInt(0);
        
		return icount;
    }
    
    
}
