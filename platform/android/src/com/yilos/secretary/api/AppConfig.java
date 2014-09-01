package com.yilos.secretary.api;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Properties;

import com.yilos.secretary.common.Constants;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/**
 * 应用程序配置类：用于保存用户相关信息及设置
 * 
 */
@SuppressLint("NewApi")
public class AppConfig {

	private final static String APP_CONFIG = "config";
	
	private static final String FILEPATH = Constants.YILOS_SDPATH+"/files";
	
	private static final String FILENAME = "config.properties";

	private Context mContext;

	private static AppConfig appConfig;

	public static AppConfig getAppConfig(Context context) {
		if (appConfig == null) {
			appConfig = new AppConfig();
			appConfig.mContext = context;
		}
		return appConfig;
	}

	/**
	 * 获取Preference设置
	 */
	public static SharedPreferences getSharedPreferences(Context context) {
		return PreferenceManager.getDefaultSharedPreferences(context);
	}

	
	public String get(String key) {
		Properties props = get();
		return (props != null) ? props.getProperty(key) : null;
	}

	public Properties get() {
		FileInputStream fis = null;
		Properties props = new Properties();
		try {
			String  file_path =  FILEPATH+"/"+FILENAME;
			fis = new FileInputStream(file_path);
			props.load(fis);
		} catch (Exception e) {
		} finally {
			try {
				fis.close();
			} catch (Exception e) {
			}
		}
		return props;
	}

	private void setProps(Properties p) {
		FileOutputStream fos = null;
		try {
			
			File dirConf = new File(FILEPATH);
			
			if (!dirConf.exists()) {
				dirConf.mkdirs();
			}
			String  file_path =  FILEPATH+"/"+FILENAME;
			File f = new File(file_path);
			
			if (!f.exists()) // 判断文件是否存在
			{ 
				f.createNewFile(); // 创建文件
			}
			
			fos = new FileOutputStream(f);

			p.store(fos, null);
			fos.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				fos.close();
			} catch (Exception e) {
			}
		}
	}

	public void set(Properties ps) {
		Properties props = get();
		props.putAll(ps);
		setProps(props);
	}

	public void set(String key, String value) {
		Properties props = get();
		props.setProperty(key, value);
		setProps(props);
	}

	public void remove(String... key) {
		Properties props = get();
		for (String k : key)
			props.remove(k);
		setProps(props);
	}
}