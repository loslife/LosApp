package com.yilos.secretary.database;

import java.io.File;
import java.io.IOException;

import android.content.Context;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.common.Constants;

public class SDBHelper 
{
	    public static void createDB(Context ctx,String name) {
			File databasefloder = new File(Constants.YILOS_SDPATH + ".database");
			if (!databasefloder.exists()) {
				databasefloder.mkdirs();
			}
			String DBName = Constants.YILOS_SDPATH + ".database/" + name;
			AppContext.getInstance(ctx).setDBName(DBName);
			AppContext.getInstance(ctx).setFirstRun(false);
			File f = new File(DBName);
			if (!f.exists()) { // 判断文件是否存在
				try {
					f.createNewFile(); // 创建文件
					AppContext.getInstance(ctx).setFirstRun(true);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
}