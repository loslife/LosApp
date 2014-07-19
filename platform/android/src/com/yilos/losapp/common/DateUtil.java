package com.yilos.losapp.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtil {
	// 用来全局控制 上一周，本周，下一周的周数变化
	private static int weeks = 0;

	// 获得当前日期与本周一相差的天数
	private int getMondayPlus() {
		Calendar cd = Calendar.getInstance();

		// 获得今天是一周的第几天，星期日是第一天，星期二是第二天......
		int dayOfWeek = cd.get(Calendar.DAY_OF_WEEK);
		if (dayOfWeek == 1) {
			return -6;
		} else {
			return 2 - dayOfWeek;
		}
	}

	// 获得上周星期一的日期
	public String getPreviousMonday() {
		weeks--;
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus + 7 * weeks);
		Date monday = currentDate.getTime();
		SimpleDateFormat df = new SimpleDateFormat("MM月dd日");
		String preMonday = df.format(monday);
		return preMonday;
	}

	// 获得上周星期一的日期
	public String getCurrentMonday() {
		weeks = 0;
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus);
		Date monday = currentDate.getTime();
		SimpleDateFormat df = new SimpleDateFormat("MM月dd日");
		String preMonday = df.format(monday);
		return preMonday;
	}

	// 获得上周星期一的日期
	public String getNextMonday() {
		weeks++;
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus + 7 * weeks);
		Date monday = currentDate.getTime();
		SimpleDateFormat df = new SimpleDateFormat("MM月dd日");
		String preMonday = df.format(monday);
		return preMonday;
	}

	// 获得相应周的周日的日期
	public String getSunday() {
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus + 7 * weeks + 6);
		Date monday = currentDate.getTime();
		SimpleDateFormat df = new SimpleDateFormat("MM月dd日");
		String preMonday = df.format(monday);
		return preMonday;
	}

	public String getCurDateMonday() {
		
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus + 7 * weeks);
		Date monday = currentDate.getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日");
		String curDateMonday = df.format(monday);
		
		return curDateMonday;
	}
	
	public String[] getWeeksday()
	{
        String[] weekdays = new String[7];
		int mondayPlus = this.getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		for(int i=0;i<7;i++)
		{
			currentDate.add(GregorianCalendar.DATE, mondayPlus + 7 * weeks+i);
			Date monday = currentDate.getTime();
			SimpleDateFormat df = new SimpleDateFormat("MM月dd日");
			weekdays[i] = df.format(monday);
		}

		return weekdays;
	}

	/**
	 * 获取某年某月的最大天数
	 * @param year
	 * @param month
	 * @return
	 */
	public static int maxDays(int year, int month) {
		int maxDays = 0;
		
			if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) { // 是闰年
				if (month == 2) {
					maxDays = 29; // 闰年2月29天
				} else if (month == 1 || month == 3 || month == 5 || month == 7
						|| month == 8 || month == 10 || month == 12) {
					maxDays = 31;
					// 1、3、5、7、8、10、12月都是31天
				} else {
					maxDays = 30; // 其他月份都是30天
				}
			} else { // 非闰年
				if (month == 2) {
					maxDays = 28; // 非闰年2月28天
				} else if (month == 1 || month == 3 || month == 5 || month == 7
						|| month == 8 || month == 10 || month == 12) {
					maxDays = 31;
					// 1、3、5、7、8、10、12月都是31天
				} else {
					maxDays = 30; // 其他月份都是30天
				}
			}
	
		return maxDays;
	}
	
	public static String dateToString(String time, String format) {
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		Date curDate = new Date(Long.valueOf(time));
		Calendar cal = Calendar.getInstance();
	    String str = formatter.format(curDate);
		
		return str;
	}
	
	public static String[]  getDayarr(String year,String month,String dateType)
	{
		String[] days = null;
		int maxlength = 24;
		if(!"day".equals(dateType))
		{
			maxlength =  maxDays(Integer.valueOf(year),Integer.valueOf(month));;
		}

			days = new String[maxlength];
			
			for(int i = 1;i<=maxlength;i++)
			{
				days[i-1]= String.valueOf(i);
			}
		
		return days;
	}

}
