package com.yilos.secretary;

import java.util.Arrays;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.View;

public class ChartView extends View {

	DisplayMetrics dm = getResources().getDisplayMetrics(); 
	public int XPoint = 150; // 原点的X坐标
	public int YPoint = dm.heightPixels+150; // 原点的Y坐标
	
	public int XLength = dm.widthPixels-200; // X轴的长度
	public int YLength = dm.heightPixels/2+200; // Y轴的长度
	public int scrollLength = YLength;
	
	public int XScale = XLength/6; // X的刻度长度
	public int YScale = 60; // Y的刻度长度
	
	public String[] XLabel; // X的刻度
	public String[] YLabel; // Y的刻度
	public int[] Data; // 数据

	 final int[] colors = new int[]{           
             R.color.vone,  
             R.color.vtwo,  
             R.color.vthree,  
             R.color.vgeneral,  
             R.color.blue,                 
         }; 
	 
	 int[] sortdataArray = null;
	 
	 int top_one = 0;
	 int top_two = 0;
	 int top_three = 0;

	public ChartView(Context context, AttributeSet attr) {
		super(context, attr);

	}
	
	public ChartView(Context context, String[] XLabels, String[] YLabels, int[] AllData) {
		super(context);
		SetInfo(XLabels, YLabels,AllData);
	}

	public void SetInfo(String[] XLabels, String[] YLabels, int[] AllData) {
		XLabel = XLabels;
		YLabel = YLabels;
		Data = AllData;
		YLength = XLabels.length*YScale;
		sortdataArray = new int[AllData.length];
		System.arraycopy(AllData, 0, sortdataArray, 0, AllData.length);
		Arrays.sort(sortdataArray);
		
		if(XLabels.length==7)
		{
			YPoint =YLength+100;
			scrollLength = YLength+200;
		}
		else if(XLabels.length==24)
		{
			YPoint = YLength+100;
			scrollLength = YLength+200;
		}
		else if(XLabels.length==31)
		{
			
			YPoint = YLength+100;
			scrollLength = YLength+200;
		}
		else if(XLabels.length==30)
		{
			
			YPoint = YLength+100;
			scrollLength =YLength+200;
		}
		else
		{
			
			YPoint = YLength+100;
			scrollLength = YLength+200;
		}
		
		//TOP3
		top_one = sortdataArray[AllData.length-1];
		top_two = sortdataArray[AllData.length-2];;
		top_three = sortdataArray[AllData.length-3];;
		YLabel = new String[]{"0",1*(top_one/5+1)+"",2*(top_one/5+1)+"",3*(top_one/5+1)+"",4*(top_one/5+1)+"",5*(top_one/5+1)+""};
	}

	@SuppressLint("DrawAllocation")
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);// 重写onDraw方法

		Resources res = this.getResources();
		// canvas.drawColor(Color.WHITE);//设置背景颜色
		Paint paint = new Paint();
		paint.setStyle(Paint.Style.FILL);
		paint.setAntiAlias(true);// 去锯齿
		paint.setColor(res.getColor(R.color.vgeneral));// 颜色
		paint.setStrokeWidth(1);

		Paint paint1 = new Paint();
		paint1.setStyle(Paint.Style.STROKE);
		paint1.setAntiAlias(true);// 去锯齿
		
		paint1.setTextSize(36); // 设置轴文字大小

		// 设置Y轴(对于系统来讲屏幕的原点在左上角）
		canvas.drawLine(XPoint, YPoint - YLength, XPoint, YPoint, paint); // 轴线
		for (int i = 1; i  <= XLabel.length; i++) {
			// canvas.drawLine(XPoint, YPoint - YLength +i * YScale, XPoint + 5,
			// YPoint - YLength +i * YScale, paint); // 刻度 XPoint+5画出了一条短的小横线
			try {
				paint1.setColor(res.getColor(R.color.gray_text));
				canvas.drawText(XLabel[i-1], XPoint - 120, YPoint - YLength + i
						* YScale+15, paint1); // 文字
			} catch (Exception e) {
			}
		}

		// 设置X轴
		canvas.drawLine(XPoint, YPoint - YLength, XPoint + XLength+10, YPoint
				- YLength, paint); // 轴线
		for(int i = 0; i < YLabel.length; i++)
		{
			paint1.setColor(res.getColor(R.color.black_text));
			canvas.drawText(YLabel[i], XPoint + i * XScale - 5, YPoint
					- YLength-15, paint1); // 文字
		}
		for (int i = 0; i < XLabel.length; i++) {
			/*
			 * canvas.drawLine(XPoint + i * XScale, YPoint-YLength, XPoint + i *
			 * XScale, YPoint- YLength- 5, paint); // 刻度
			 */try {
				
				paint.setColor(res.getColor(colors[3]));
				// 数据值
				if (i > 0 && YCoord(Data[i - 1]) != -999
						&& YCoord(Data[i]) != -999) // 保证有效数据
					canvas.drawLine(YCoord(Data[i - 1])+8, YPoint - YLength + i
							* YScale, YCoord(Data[i])+8, YPoint - YLength
							+ (i + 1) * YScale, paint);
				if(Data[i]==top_one&&Data[i]!=0)
	             {
	                 paint.setColor(res.getColor(colors[0]));
	             }
				 else if (Data[i]==top_two&&Data[i]!=0)
	             {
					 paint.setColor(res.getColor(colors[1]));
	             }
				 else if(Data[i]==top_three&&Data[i]!=0)
				 {
					 paint.setColor(res.getColor(colors[2]));
				 }

				canvas.drawRect(new Rect(YCoord(Data[i]),YPoint
						- YLength + (i + 1) * YScale,YCoord(Data[i])+15,YPoint
						- YLength + (i + 1) * YScale+15), paint);
				canvas.drawText(Data[i] + "人", YCoord(Data[i]) + 12, YPoint
						- YLength + (i + 1) * YScale, paint1); // 文字
			} 
			 catch (Exception e)
			{
				 
			}
		}

		paint.setTextSize(16);
	}

	private int YCoord(int y0) // 计算绘制时的Y坐标，无数据时返回-999
	{
		int y;
		try {
			y = y0;
		} catch (Exception e) {
			return -999; // 出错则返回-999
		}
		try {
			return XPoint + y * XScale / Integer.parseInt(YLabel[1]);
		} catch (Exception e) {
		}
		return y;
	}

	
	@Override
	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		setMeasuredDimension(dm.widthPixels,  scrollLength);
	}

}
