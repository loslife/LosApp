package com.yilos.secretary.chartview;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.DisplayMetrics;
import android.view.View;

import com.yilos.secretary.R;
import com.yilos.secretary.common.ChartCalc;

public class IncomePerChartView extends View {

	private int ScrWidth, ScrHeight;

	// 演示用的百分比例,实际使用中，即为外部传入的比例参数
	private float arrPer[] = null;
	// RGB颜色数组
	private int[] arrColorRgb = { R.color.blue_outside_1,
			R.color.blue_outside_2, R.color.blue_outside_3,
			R.color.orange_outside_1, R.color.orange_outside_2 };

	private String incomePerStr[] = { "经营", "预付款" };
	private String incomeStr[] = { "服务现金/银行卡", "卖品现金/银行卡", "划卡消费" };
	private String performanceStr[] = { "开卡现金/银行卡", "充值现金/银行卡" };

	private float incomePercent[] = { 50.0f, 15.0f, 5.0f };
	private float performancePercent[] = { 15.0f, 15.0f };
	private float[] totalPercent = new float[2];

	private String strPer[] = null;

	public IncomePerChartView(Context context, float incomePercent[],
			float performancePercent[]) {
		super(context);

		// 屏幕信息
		DisplayMetrics dm = getResources().getDisplayMetrics();
		ScrHeight = dm.heightPixels;
		ScrWidth = dm.widthPixels;
		/*
		 * this.incomePercent = incomePercent; this.performancePercent =
		 * performancePercent;
		 */
	}

	@SuppressLint("DrawAllocation")
	public void onDraw(Canvas canvas) {
		// 画布背景
		canvas.drawColor(Color.WHITE);

		float cirX = ScrWidth / 4;
		float cirY = ScrHeight / 8;
		float radius = ScrWidth / 6;// 150;

		float arcLeft = cirX - radius;
		float arcTop = cirY - radius;
		float arcRight = cirX + radius;
		float arcBottom = cirY + radius;
		RectF arcRF0 = new RectF(arcLeft, arcTop, arcRight, arcBottom);

		// 画笔初始化
		Paint PaintArc = new Paint();
		PaintArc.setAntiAlias(true);

		Paint PaintLabel = new Paint();
		PaintLabel.setColor(Color.GRAY);
		PaintLabel
				.setTextSize(getResources().getDimension(R.dimen.Text_size_m));

		// 位置计算类
		ChartCalc xcalc = new ChartCalc();

		float Percentage = 0.0f;
		float CurrPer = 0.0f;
		int i = 0;
		int length = incomePercent.length + performancePercent.length;
		for (i = 0; i < length; i++) {

			float percent = 0.0f;
			String textStr = "";

			// 将百分比转换为饼图显示角度
			if (i < 3) {
				Percentage = 360 * (incomePercent[i] / 100);
				textStr = incomeStr[i];
				percent = (float) (Math.round(incomePercent[i] * 10)) / 10;
				totalPercent[0] += incomePercent[i];
			} else {
				Percentage = 360 * (performancePercent[i - 3] / 100);
				textStr = performanceStr[i - 3];
				percent = (float) (Math.round(performancePercent[i - 3] * 10)) / 10;
				totalPercent[1] += performancePercent[i - 3];
			}

			Percentage = (float) (Math.round(Percentage * 100)) / 100;
			// 分配颜色
			Resources res = this.getResources();

			PaintArc.setColor(res.getColor(arrColorRgb[i]));

			// 在饼图中显示所占比例
			canvas.drawArc(arcRF0, CurrPer, Percentage, true, PaintArc);
			// 计算百分比标签
			xcalc.CalcArcEndPointXY(cirX, cirY, radius - radius / 2 / 2,
					CurrPer + Percentage / 2);

			/*
			 * int textX = ScrWidth * 1 / 2 + 50; int textY = ScrHeight / 8 -
			 * (ScrWidth / 6) * 4 / 7 + 50 * i + 15;
			 * 
			 * canvas.drawRect(new Rect(textX - 24, textY - 24, textX, textY),
			 * PaintArc); canvas.drawText("  " + textStr + " " +
			 * Float.toString(percent) + "%", textX, textY, PaintLabel);
			 */

			// 下次的起始角度
			CurrPer += Percentage;

		}

		// 画圆心
		PaintArc.setColor(Color.WHITE);
		canvas.drawCircle(cirX, cirY, radius * 5 / 7, PaintArc);

		float CurrPer2 = 0.0f;
		int k = 0;
		int arrColorRgb2[] = { R.color.blue_inside, R.color.orange_inside };
		float arcLeft2 = cirX - radius * 5 / 7;
		float arcTop2 = cirY - radius * 5 / 7;
		float arcRight2 = cirX + radius * 5 / 7;
		float arcBottom2 = cirY + radius * 5 / 7;
		RectF arcRF02 = new RectF(arcLeft2, arcTop2, arcRight2, arcBottom2);
		for (k = 0; k < 2; k++) {
			// 将百分比转换为饼图显示角度

			Percentage = 360 * (totalPercent[k] / 100);

			Percentage = (float) (Math.round(Percentage * 100)) / 100;
			// 分配颜色
			Resources res = this.getResources();

			PaintArc.setColor(res.getColor(arrColorRgb2[k]));

			// 在饼图中显示所占比例
			canvas.drawArc(arcRF02, CurrPer2, Percentage, true, PaintArc);
			// 计算百分比标签
			xcalc.CalcArcEndPointXY(cirX, cirY, radius * 4 / 7, CurrPer2
					+ Percentage / 2);

			int textX = ScrWidth * 1 / 2 + 50;
			int textY = ScrHeight / 8 - (ScrWidth / 6) * 4 / 7 + 50 * k + 15;


			float incomePercent = (float) (Math.round(totalPercent[k] * 10)) / 10;

			canvas.drawRect(new Rect(textX - 24, textY - 24, textX, textY),
					PaintArc);
			canvas.drawText(
					"  " + incomePerStr[k] + " "
							+ Float.toString(incomePercent) + "%", textX,
					textY, PaintLabel);

			// 下次的起始角度
			CurrPer2 += Percentage;
		}
	}

}
