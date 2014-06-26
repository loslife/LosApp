package com.yilos.losapp.database;

import java.io.File;
import java.io.IOException;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.common.Constants;


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
    private static final int DATABASE_VERSION = 2;
    
    SQLiteDatabase db;
    
    // 数据表名
    public static final String T_MEMBERS = "t_members";
    public static final String T_MYSHOPS = "t_myshops";
    
    public static final String MYSHOP_SQL = "CREATE TABLE IF NOT EXISTS t_myshops (id integer primary key autoincrement, enterprise_id varchar(64), enterprise_name varchar(64), contact_latest_sync REAL, report_latest_sync REAL,display varchar(8), create_date REAL,order_number INTEGER);";
    public static final String MEMBER_SQL = "CREATE TABLE IF NOT EXISTS t_members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), birthday REAL, phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), latestConsumeTime REAL, totalConsume REAL, averageConsume REAL, create_date REAL, modify_date REAL);";
   


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

        // 即便程序修改重新运行，只要数据库已经创建过，就不会再进入这个onCreate方法
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
    {
        // 这个方法中主要完成更改数据库版本的操作
        db.execSQL("DROP TABLE IF EXISTS " + T_MEMBERS);
        db.execSQL("DROP TABLE IF EXISTS " + T_MYSHOPS);
        onCreate(db);
    }

    @Override
    public void onOpen(SQLiteDatabase db)
    {
        super.onOpen(db);
        // 每次打开数据库之后首先被执行
    }
    
 
}
