package com.yilos.secretary.common;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.util.Log;


public class ActivityControlUtil {


    /**
     * activityList用以存储开启的Activity。
     */
    private static List<Activity> activityList = new ArrayList<Activity>();

    public static List<Activity> getActivityList()
    {
        return activityList;
    }

    public static void setActivityList(List<Activity> activityList)
    {
        ActivityControlUtil.activityList = activityList;
    }

    /**
     * 从列表中删除输入的Activity。<br>
     * 
     * @author 刘文杨
     * @param 删除了的activity。
     */
    public static void remove(Activity activity)
    {

        activityList.remove(activity);

    }

    /**
     * 在BaseActivity的onCreat中调用，每个继承了BaseActivity的Activity都会把自身传进activityList中。<br>
     * 
     * @author 刘文杨
     * @param activity
     */
    public static void add(Activity activity)

    {

        activityList.add(activity);

    }

    /**
     * 在list中取出activity逐个finish。<br>
     * 
     * @author 刘文杨
     */
    public static void finishAllActivities()
    {
        if (null == activityList.get(0))
        {
            Log.e("ActivityControlUtil",
                    "ActivityControlUtil --- Well ,this path was blocked since no activity created.");
        }
        else
        {
            for (Activity activity : activityList)
            {
                activity.finish();
            }
        }

    }


}
