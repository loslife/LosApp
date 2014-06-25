package com.yilos.losapp.database;

import java.io.File;
import java.io.IOException;

import android.content.Context;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.common.Constants;

public class SDBHelper 
{
	    public static void createDB(Context ctx,String name) {
			File databasefloder = new File(Constants.YILOS_SDPATH + ".database");
			if (!databasefloder.exists()) {
				databasefloder.mkdirs();
			}
			String DBName = Constants.YILOS_SDPATH + ".database/" + name;
			File f = new File(DBName);

			if (!f.exists()) { // 判断文件是否存在
				try {
					f.createNewFile(); // 创建文件
					AppContext.getInstance(ctx).setDBName(DBName);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
}
