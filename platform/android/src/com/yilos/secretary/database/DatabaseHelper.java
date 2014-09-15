package com.yilos.secretary.database;

import java.io.File;
import java.io.IOException;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.common.Constants;


import android.annotation.SuppressLint;
import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Environment;

public class DatabaseHelper extends SQLiteOpenHelper
{

    // 数据库版本号
    private static final int DATABASE_VERSION = 1;
    
    SQLiteDatabase db;
    
    // 数据表名
    public static final String T_MEMBERS = "t_members";
    public static final String T_MYSHOPS = "t_myshops";
    
    public static final String EMP_PER_DAY = "employee_performance_day";
    public static final String EMP_PER_MONTH = "employee_performance_month";
    public static final String EMP_PER_WEEK = "employee_performance_week";
    
    public static final String SER_PER_DAY = "service_performance_day";
    public static final String SER_PER_MONTH = "service_performance_month";
    public static final String SER_PER_WEEK = "service_performance_week";
    
    public static final String BIZ_PER_DAY = "biz_performance_day";
    public static final String BIZ_PER_WEEK = "biz_performance_week";
    public static final String BIZ_PER_MONTH = "biz_performance_month";
    
    public static final String CUST_COUNT_DAY = "customer_count_day";
    public static final String CUST_COUNT_MONTH = "customer_count_month";
    public static final String CUST_COUNT_WEEK = "customer_count_week";
    
    public static final String MYSHOP_SQL = "CREATE TABLE IF NOT EXISTS t_myshops (id integer primary key autoincrement, enterprise_id varchar(64), enterprise_name varchar(64), contact_latest_sync REAL, report_latest_sync REAL,enterprise_account varchar(32),display varchar(8), create_date REAL,order_number INTEGER);";
    
    public static final String MEMBER_SQL = "CREATE TABLE IF NOT EXISTS t_members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32),sex varchar(8), birthday REAL, phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), latestConsumeTime REAL, totalConsume REAL, averageConsume REAL,cardStr varchar(128), create_date REAL, modify_date REAL);";

    public static final String EMPLOYEE_DAY_SQL = "CREATE TABLE IF NOT EXISTS employee_performance_day (id integer primary key autoincrement, record_id varchar(64), enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL,  employee_name varchar(16), year integer, month integer, day integer);";

    public static final String EMPLOYEE_MONTH_SQL = "CREATE TABLE IF NOT EXISTS employee_performance_month (id integer primary key autoincrement, record_id varchar(64), enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL,employee_name varchar(16), year integer, month integer, day integer);";
    
    public static final String EMPLOYEE_WEEK_SQL = "CREATE TABLE IF NOT EXISTS employee_performance_week (id integer primary key autoincrement, record_id varchar(64), enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_name varchar(16), year integer, month integer, day integer);";

    public static final String SERVICE_DAY_SQL= "CREATE TABLE IF NOT EXISTS service_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    public static final String SERVICE_WEEK_SQL = "CREATE TABLE IF NOT EXISTS service_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    public static final String SERVICE_MONTH_SQL = "CREATE TABLE IF NOT EXISTS service_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";

    public static final String BIZ_DAY_SQL = "CREATE TABLE IF NOT EXISTS biz_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";

    public static final String BIZ_WEEK_SQL = "CREATE TABLE IF NOT EXISTS biz_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    public static final String BIZ_MONTH_SQL = "CREATE TABLE IF NOT EXISTS biz_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    public static final String CUSTOMER_DAY_SQL = "CREATE TABLE IF NOT EXISTS customer_count_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    public static final String CUSTOMER_MONTH_SQL = "CREATE TABLE IF NOT EXISTS customer_count_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    public static final String CUSTOMER_WEEK_SQL = "CREATE TABLE IF NOT EXISTS customer_count_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    public static final String INCOME_DAY_PERFORMANCE = "CREATE TABLE IF NOT EXISTS income_performance_day(id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
            +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
            + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
            + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
            + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
            + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";
    
    public static final String INCOME_WEEK_PERFORMANCE = "CREATE TABLE IF NOT EXISTS income_performance_week(id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
            +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
            + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
            + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
            + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
            + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";
    
    public static final String INCOME_MONTH_PERFORMANCE = "CREATE TABLE IF NOT EXISTS income_performance_month(id INTEGER NOT NULL primary key AUTOINCREMENT,enterprise_id varchar(64),"
            +"total_income REAL,total_prepay REAL,total_paidin REAL,total_paidin_bank REAL,total_paidin_cash REAL,"
            + "service_cash REAL,service_bank REAL,product_cash REAL,product_bank REAL,card REAL,newcard_cash REAL,"
            + "newcard_bank REAL,rechargecard_cash REAL,rechargecard_bank REAL,year integer, month integer, day integer, "
            + "create_date REAL,modify_date REAL,syncindex REAL,synctag INTEGER,status integer,def_str1 varchar(32),"
            + "def_int1 REAL,def_int2 REAL,def_int3 REAL);";

    
    // 构造函数，调用父类SQLiteOpenHelper的构造函数
    @SuppressLint("NewApi")
	public DatabaseHelper(Context context, String name, CursorFactory factory,
            int version, DatabaseErrorHandler errorHandler)
    {
        super(context, name, factory, version, errorHandler);
    }

    // SQLiteOpenHelper的构造函数参数：
    // context：上下文环境
    // name：数据库名字
    // factory：游标工厂（可选）
    // version：数据库模型版本号
    public DatabaseHelper(Context context, String name, CursorFactory factory,
            int version)
    {
        super(context, name, factory, version);
    }

    public DatabaseHelper(Context context)
    {
        super(context, AppContext.getInstance(context).getDBName(), null, DATABASE_VERSION);
        // 数据库实际被创建是在getWritableDatabase()或getReadableDatabase()方法调用时
    }

    @Override
    public void onCreate(SQLiteDatabase db)
    {
        // 执行创建表的SQL语句
        db.execSQL(MYSHOP_SQL);
        db.execSQL(MEMBER_SQL);
        
        db.execSQL(EMPLOYEE_DAY_SQL);
        db.execSQL(EMPLOYEE_MONTH_SQL);
        db.execSQL(EMPLOYEE_WEEK_SQL);
        
        db.execSQL(SERVICE_DAY_SQL);
        db.execSQL(SERVICE_WEEK_SQL);
        db.execSQL(SERVICE_MONTH_SQL);
        
        db.execSQL(BIZ_DAY_SQL);
        db.execSQL(BIZ_WEEK_SQL);
        db.execSQL(BIZ_MONTH_SQL);
        
        db.execSQL(CUSTOMER_DAY_SQL);
        db.execSQL(CUSTOMER_MONTH_SQL);
        db.execSQL(CUSTOMER_WEEK_SQL);
        
        /*db.execSQL(INCOME_DAY_PERFORMANCE);
        db.execSQL(INCOME_WEEK_PERFORMANCE);
        db.execSQL(INCOME_MONTH_PERFORMANCE);*/

        // 即便程序修改重新运行，只要数据库已经创建过，就不会再进入这个onCreate方法
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
    {
        // 这个方法中主要完成更改数据库版本的操作
        db.execSQL("DROP TABLE IF EXISTS " + T_MEMBERS);
        db.execSQL("DROP TABLE IF EXISTS " + T_MYSHOPS);
 
        db.execSQL("DROP TABLE IF EXISTS " + EMP_PER_DAY);
        db.execSQL("DROP TABLE IF EXISTS " + EMP_PER_MONTH);
        db.execSQL("DROP TABLE IF EXISTS " + EMP_PER_WEEK);
        
        db.execSQL("DROP TABLE IF EXISTS " + SER_PER_DAY);
        db.execSQL("DROP TABLE IF EXISTS " + SER_PER_MONTH);
        db.execSQL("DROP TABLE IF EXISTS " + SER_PER_WEEK);
        
        db.execSQL("DROP TABLE IF EXISTS " + BIZ_PER_DAY);
        db.execSQL("DROP TABLE IF EXISTS " + BIZ_PER_WEEK);
        db.execSQL("DROP TABLE IF EXISTS " + BIZ_PER_MONTH);
        
        db.execSQL("DROP TABLE IF EXISTS " + CUST_COUNT_DAY);
        db.execSQL("DROP TABLE IF EXISTS " + CUSTOMER_MONTH_SQL);
        db.execSQL("DROP TABLE IF EXISTS " + CUSTOMER_WEEK_SQL);

        /*db.execSQL("DROP TABLE IF EXISTS " + INCOME_DAY_PERFORMANCE);
        db.execSQL("DROP TABLE IF EXISTS " + INCOME_WEEK_PERFORMANCE);
        db.execSQL("DROP TABLE IF EXISTS " + INCOME_MONTH_PERFORMANCE);*/

        onCreate(db);
    }

    @Override
    public void onOpen(SQLiteDatabase db)
    {
        super.onOpen(db);
        // 每次打开数据库之后首先被执行
    }
    
 
}
