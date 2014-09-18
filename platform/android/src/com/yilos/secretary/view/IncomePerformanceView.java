package com.yilos.secretary.view;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.IncomePerformanceBean;
import com.yilos.secretary.chartview.IncomePerChartView;

public class IncomePerformanceView {

	// 绘制服务业绩 incomeperformance
	public void setIncomePerChartView(Context context, View v,
			TextView timetype, IncomePerformanceBean incomeperformance,
			IncomePerformanceBean prevIncomePerformance) {

		float total_income = 0.0f;// 收入
		float total_prepay = 0.0f;// 预付
		float total_paidin = 0.0f;// 实收

		float product = 0.0f;
		float total = 0.0f;

		float comparePrevIncome = 0.0f;
		float comparePrevPrepay = 0.0f;
		float comparePrevPaidin = 0.0f;

		float prev_income = 0.0f;
		float prev_prepay = 0.0f;
		float prev_paidin = 0.0f;

		// 增长
		float percent_income_add = 0.0f;
		float percent_prepay_add = 0.0f;
		float percent_paidin_add = 0.0f;

		if (incomeperformance.get_id() == null) {
			((LinearLayout) v.findViewById(R.id.income_empty))
					.setVisibility(View.VISIBLE);
			((LinearLayout) v.findViewById(R.id.income_annularLayout))
					.setVisibility(View.GONE);
			((View) v.findViewById(R.id.incomemidview)).setVisibility(View.GONE);
			((LinearLayout) v.findViewById(R.id.incomedetail))
					.setVisibility(View.GONE);
			((TextView) v.findViewById(R.id.incometotal)).setText("￥0.0");

			return;
		} else {
			((LinearLayout) v.findViewById(R.id.income_empty))
					.setVisibility(View.GONE);
			((LinearLayout) v.findViewById(R.id.income_annularLayout))
					.setVisibility(View.VISIBLE);
			((View) v.findViewById(R.id.incomemidview)).setVisibility(View.VISIBLE);
			((LinearLayout) v.findViewById(R.id.incomedetail))
					.setVisibility(View.VISIBLE);
		}

		if (null != incomeperformance.get_id()) {
			total_income = Float
					.valueOf(incomeperformance.getTotal_income() == null ? "0.0"
							: incomeperformance.getTotal_income());// 收入
			total_prepay = Float
					.valueOf(incomeperformance.getTotal_prepay() == null ? "0.0"
							: incomeperformance.getTotal_prepay());
			;// 预付
			total_paidin = Float
					.valueOf(incomeperformance.getTotal_paidin() == null ? "0.0"
							: incomeperformance.getTotal_paidin());
			;// 实收

			((TextView) v.findViewById(R.id.incomedata)).setText("￥"
					+ (float) (Math.round(total_income * 10)) / 10);
			((TextView) v.findViewById(R.id.prepaydata)).setText("￥"
					+ (float) (Math.round(total_prepay * 10)) / 10);
			((TextView) v.findViewById(R.id.paidindata)).setText("￥"
					+ (float) (Math.round(total_paidin * 10)) / 10);

			total = total_income + total_prepay;
			total = (float) (Math.round(total * 10)) / 10;
			if (null != prevIncomePerformance.get_id()) {

				prev_income = Float.valueOf(prevIncomePerformance
						.getTotal_income());
				prev_prepay = Float.valueOf(prevIncomePerformance
						.getTotal_prepay());
				prev_paidin = Float.valueOf(prevIncomePerformance
						.getTotal_paidin());

				comparePrevIncome = total_income - prev_income;
				comparePrevPrepay = total_prepay - prev_prepay;
				comparePrevPaidin = total_paidin - prev_paidin;

				// 增长
				percent_income_add = (Math
						.round((comparePrevIncome / prev_income) * 1000)) / 10;
				percent_prepay_add = (Math
						.round((comparePrevPrepay / prev_prepay) * 1000)) / 10;
				percent_paidin_add = (Math
						.round((comparePrevPaidin / prev_paidin) * 1000)) / 10;

			} else {
				comparePrevIncome = total_income;
				comparePrevPrepay = total_prepay;
				comparePrevPaidin = total_paidin;

				percent_income_add = 100.0f;
				percent_prepay_add = 100.0f;
				percent_paidin_add = 100.0f;
			}
		}
		((TextView) v.findViewById(R.id.incometotal)).setText("￥" + total);

		// 增长
		float percentForIncome = 0.0f;
		float percentForPrepay = 0.0f;

		String total_paidin_bank = incomeperformance.getTotal_paidin_bank() == null ? "0.0"
				: incomeperformance.getTotal_paidin_bank();
		String total_paidin_cash = incomeperformance.getTotal_paidin_cash() == null ? "0.0"
				: incomeperformance.getTotal_paidin_cash();

		String service_cash = incomeperformance.getService_cash() == null ? "0.0"
				: incomeperformance.getService_cash();
		String service_bank = incomeperformance.getService_bank() == null ? "0.0"
				: incomeperformance.getService_bank();
		float percentForService = (Float.valueOf(service_cash) + Float
				.valueOf(service_bank)) / total;// 服务

		String product_cash = incomeperformance.getProduct_cash() == null ? "0.0"
				: incomeperformance.getProduct_cash();
		String product_bank = incomeperformance.getProduct_bank() == null ? "0.0"
				: incomeperformance.getProduct_bank();
		float percentForProduct= (Float.valueOf(product_cash) + Float
				.valueOf(product_bank)) / total;// 卖品

		String card = incomeperformance.getCard() == null ? "0.0"
				: incomeperformance.getCard();
		float percentForCard = Float.valueOf(card) / total;// 划卡

		// 收入比重
		percentForIncome = percentForService + percentForProduct
				+ percentForCard;

		String newcard_cash = incomeperformance.getNewcard_cash() == null ? "0.0"
				: incomeperformance.getNewcard_cash();
		String newcard_bank = incomeperformance.getNewcard_bank() == null ? "0.0"
				: incomeperformance.getNewcard_bank();
		float percentForNewcardCash = (Float.valueOf(newcard_cash) + Float
				.valueOf(newcard_bank)) / total;// 开卡

		String rechargecard_cash = incomeperformance.getRechargecard_cash() == null ? "0.0"
				: incomeperformance.getRechargecard_cash();
		String rechargecard_bank = incomeperformance.getRechargecard_bank() == null ? "0.0"
				: incomeperformance.getRechargecard_bank();
		float percentForRechargecard = (Float.valueOf(rechargecard_cash) + Float
				.valueOf(rechargecard_bank)) / total;// 充值

		// 预付款比重
		percentForPrepay = percentForNewcardCash + percentForRechargecard;

		((TextView) v.findViewById(R.id.product_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(product_cash) * 10)) / 10
				+ "/￥" + (float) (Math.round(Float.valueOf(product_bank) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.service_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(service_cash) * 10)) / 10
				+ "/￥" + (float) (Math.round(Float.valueOf(service_bank) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.rechargecard_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(rechargecard_cash) * 10))
				/ 10 + "/￥"
				+ (float) (Math.round(Float.valueOf(rechargecard_bank) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.newcard_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(newcard_cash) * 10)) / 10
				+ "/￥" + (float) (Math.round(Float.valueOf(newcard_bank) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.paidin_cash_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(total_paidin_cash) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.paidin_bank_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(total_paidin_bank) * 10))
				/ 10);

		((TextView) v.findViewById(R.id.card_num)).setText("￥"
				+ (float) (Math.round(Float.valueOf(card) * 10)) / 10);

		((TextView) v.findViewById(R.id.incomedata)).setTextColor(context
				.getResources().getColor(R.color.black_text));
		((TextView) v.findViewById(R.id.prepaydata)).setTextColor(context
				.getResources().getColor(R.color.black_text));
		((TextView) v.findViewById(R.id.paidindata)).setTextColor(context
				.getResources().getColor(R.color.black_text));

		((ImageView) v.findViewById(R.id.incomeicon))
				.setImageResource(R.drawable.down);
		((ImageView) v.findViewById(R.id.prepayicon))
				.setImageResource(R.drawable.down);
		((ImageView) v.findViewById(R.id.paidinicon))
				.setImageResource(R.drawable.down);

		if (comparePrevIncome > 0.0) {
			((ImageView) v.findViewById(R.id.incomeicon))
					.setImageResource(R.drawable.up);
			((TextView) v.findViewById(R.id.incomedata)).setTextColor(context
					.getResources().getColor(R.color.orange_bg));
		}

		if (comparePrevPrepay > 0.0) {
			((ImageView) v.findViewById(R.id.prepayicon))
					.setImageResource(R.drawable.up);
			((TextView) v.findViewById(R.id.prepaydata)).setTextColor(context
					.getResources().getColor(R.color.orange_bg));
		}

		if (comparePrevPaidin > 0.0) {
			((ImageView) v.findViewById(R.id.paidinicon))
					.setImageResource(R.drawable.up);
			((TextView) v.findViewById(R.id.paidindata)).setTextColor(context
					.getResources().getColor(R.color.orange_bg));
		}

		comparePrevIncome = (float) (Math.round(Float
				.valueOf(comparePrevIncome) * 10)) / 10;
		comparePrevPrepay = (float) (Math.round(Float
				.valueOf(comparePrevPrepay) * 10)) / 10;
		comparePrevPaidin = (float) (Math.round(Float
				.valueOf(comparePrevPaidin) * 10)) / 10;

		((TextView) v.findViewById(R.id.toprev_incomedata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevIncome
				+ " " + showPercent(percent_income_add) + "%");
		((TextView) v.findViewById(R.id.toprev_prepaydata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevPrepay
				+ " " + showPercent(percent_prepay_add) + "%");
		((TextView) v.findViewById(R.id.toprev_paidindata)).setText("比上"
				+ timetype.getText().toString() + ": " + comparePrevPaidin
				+ " " + showPercent(percent_paidin_add) + "%");

		/*
		 * newcard = (float) (Math.round(newcard * 1000)) / 10; recharge =
		 * (float) (Math.round(recharge * 1000)) / 10; service = (float)
		 * (Math.round(service * 1000)) / 10; product = (float)
		 * (Math.round(product * 1000)) / 10;
		 */
		float incomePercent[] = {
				(float) (Math.round(Float.valueOf(percentForService) * 1000)) / 10,
				(float) (Math.round(Float.valueOf(percentForProduct) * 1000)) / 10,
				(float) (Math.round(Float.valueOf(percentForCard) * 1000)) / 10 };
		float performancePercent[] = {
				(float) (Math.round(Float.valueOf(percentForNewcardCash) * 1000)) / 10,
				(float) (Math.round(Float.valueOf(percentForRechargecard) * 1000)) / 10 };
		LinearLayout annularLayout = (LinearLayout) v
				.findViewById(R.id.income_annularLayout);
		annularLayout.removeAllViews();
		IncomePerChartView panelDountView = new IncomePerChartView(context,
				incomePercent, performancePercent);
		annularLayout.addView(panelDountView);
	}

	public String showPercent(float percent) {
		if (percent > 0.0f) {
			return "+" + percent;
		}
		return String.valueOf(percent);
	}
}
