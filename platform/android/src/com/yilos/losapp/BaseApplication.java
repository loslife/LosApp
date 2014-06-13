package com.yilos.losapp;

import java.util.LinkedList;
import java.util.List;

import android.app.Activity;
import android.app.Application;

import com.yilos.losapp.util.CrashHandler;

public class BaseApplication extends Application {

	private static BaseApplication instance;

	private List<Activity> activityList = new LinkedList<Activity>();

	@Override
	public void onCreate() {
		super.onCreate();
		instance = this;
		CrashHandler.getInstance().init(this);
	}

	public static BaseApplication getInstance() {
		return instance;
	}

	public synchronized void addActivity(Activity activity) {
		activityList.add(activity);
	}

	public void exit() {
		for (Activity activity : activityList) {
			try {
				activity.finish();
			} catch (Throwable e) {
			}
		}
		System.exit(0);
	}
}
