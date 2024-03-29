package com.yilos.secretary.common;

import java.lang.Thread.UncaughtExceptionHandler;

import org.apache.log4j.Logger;

import com.yilos.secretary.AppContext;
import com.yilos.secretary.BaseApplication;
import com.yilos.secretary.LoginActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Looper;
import android.widget.Toast;

public class CrashHandler implements UncaughtExceptionHandler {
	private static final Logger LOGGER = LoggerFactory
			.getLogger(CrashHandler.class);
	// 系统默认的UncaughtException处理类
	private Thread.UncaughtExceptionHandler mDefaultHandler;
	// CrashHandler实例
	private static CrashHandler INSTANCE;
	// 程序的Context对象
	private Context mContext;

	/** 保证只有一个CrashHandler实例 */
	private CrashHandler() {
	}

	/** 获取CrashHandler实例 ,单例模式 */
	public static CrashHandler getInstance() {
		return null == INSTANCE ? new CrashHandler() : INSTANCE;
	}

	/**
	 * 初始化
	 * 
	 * @param context
	 */
	public void init(Context context) {
		mContext = context;
		// 获取系统默认的UncaughtException处理器
		mDefaultHandler = Thread.getDefaultUncaughtExceptionHandler();
		// 设置该CrashHandler为程序的默认处理器
		Thread.setDefaultUncaughtExceptionHandler(this);
	}

	/**
	 * 当UncaughtException发生时会转入该函数来处理
	 */
	@Override
	public void uncaughtException(Thread thread, Throwable ex) {
		if (!handleException(ex) && mDefaultHandler != null) {
			// 如果用户没有处理则让系统默认的异常处理器来处理
			mDefaultHandler.uncaughtException(thread, ex);
		} else {
			try {
				Thread.sleep(3000);
			} catch (InterruptedException e) {
				LOGGER.error("", e);
			}
            //退出程序  
	           
            AppContext.getInstance(mContext).setLogin(false);
            ActivityControlUtil.finishAllActivities();// finish所有Activity
            android.os.Process.killProcess(android.os.Process.myPid());  
            System.exit(0); 
            Intent intent = new Intent(mContext, LoginActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
            Intent.FLAG_ACTIVITY_NEW_TASK);
            mContext.startActivity(intent);
		}
	}

	/**
	 * 自定义错误处理,收集错误信息 发送错误报告等操作均在此完成.
	 * 
	 * @param ex
	 * @return true:如果处理了该异常信息;否则返回false.
	 */
	private boolean handleException(Throwable ex) {
		if (ex == null) {
			return false;
		}
		// 使用Toast来显示异常信息
		new Thread() {
			@Override
			public void run() {
				Looper.prepare();
				Toast.makeText(mContext,
						"程序出现异常，即将退出。",
						Toast.LENGTH_LONG).show();
				Looper.loop();
			}
		}.start();
		// 记录日志
		LOGGER.error("程序出现异常，即将退出。", ex);
		return true;
	}
}