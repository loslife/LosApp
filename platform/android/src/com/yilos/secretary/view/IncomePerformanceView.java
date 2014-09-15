package com.yilos.secretary.view;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.IncomePerformanceBean;
import com.yilos.secretary.chartview.IncomePerChartView;
import com.yilos.secretary.chartview.ServiceGoodsChartView;

public class IncomePerformanceView {

	    // 绘制服务业绩 incomeperformance
		public void setIncomePerChartView(Context context,View v, TextView timetype,
				IncomePerformanceBean incomeperformance,
				IncomePerformanceBean prevIncomePerformance) {
			
			/*
			private String total_income;//收入
			private String total_prepay;//预付
			private String total_paidin;//实收
			private String total_paidin_bank;//实收银行
			private String total_paidin_cash;//实收现金
			private String service_cash;//服务现金
			private String service_bank;//服务银行
			private String product_cash;//卖品现金
			private String product_bank;//卖品银行
			private String card;//划卡
			private String newcard_cash;//开卡现金
			private String newcard_bank;//开卡银行
			private String rechargecard_cash;//充值现金
			private String rechargecard_bank;//充值银行
*/			
			float total_income = 0.0f;//收入
			float total_prepay = 0.0f;//预付
			float total_paidin = 0.0f;//实收
			
			float product = 0.0f;
			float total = 0.0f;

			float comparePrevIncome = 0.0f;
			float comparePrevPrepay = 0.0f;
			float comparePrevPaidin = 0.0f;

			float prev_income = 0.0f;
			float prev_prepay = 0.0f;
			float prev_paidin = 0.0f;

			float percent_income= 0.0f;
			float percent_prepay = 0.0f;
			float percent_paidin = 0.0f;

			if (incomeperformance.get_id()== null
					) {
				((LinearLayout) v.findViewById(R.id.income_empty))
						.setVisibility(View.VISIBLE);
				((LinearLayout) v.findViewById(R.id.income_annularLayout))
				.setVisibility(View.GONE);
				((View) v.findViewById(R.id.midview))
				.setVisibility(View.GONE);
				((LinearLayout) v.findViewById(R.id.performacncetext))
				.setVisibility(View.GONE);
				((TextView) v.findViewById(R.id.incometotal)).setText("￥0.0");
				
				return;
			} else {
				((LinearLayout) v.findViewById(R.id.income_empty))
						.setVisibility(View.GONE);
				((LinearLayout) v.findViewById(R.id.income_annularLayout))
				.setVisibility(View.VISIBLE);
				((View) v.findViewById(R.id.midview))
				.setVisibility(View.VISIBLE);
				((LinearLayout) v.findViewById(R.id.performacncetext))
				.setVisibility(View.VISIBLE);
			}

			if (null != incomeperformance.get_id()) {
				total_income = Float.valueOf(incomeperformance.getTotal_income());//收入
				total_prepay = Float.valueOf(incomeperformance.getTotal_prepay());;//预付
				total_paidin = Float.valueOf(incomeperformance.getTotal_paidin());;//实收
				total = total_income+total_prepay;
				total = (float) (Math.round(total * 10)) / 10;
				if (null != prevIncomePerformance.get_id()) {
					
					prev_income = Float.valueOf(prevIncomePerformance.getTotal_income());
					prev_prepay = Float.valueOf(prevIncomePerformance.getTotal_prepay());
					prev_paidin = Float.valueOf(prevIncomePerformance.getTotal_paidin());
					
					comparePrevIncome = total_income - prev_income;
					comparePrevPrepay = total_prepay - prev_prepay;
					comparePrevPaidin = total_paidin - prev_paidin;
					
					percent_income = (Math
							.round((comparePrevIncome / prev_income) * 1000)) / 10;
					percent_prepay =  (Math
							.round((comparePrevPrepay / prev_prepay) * 1000)) / 10;
					percent_paidin =  (Math
							.round((comparePrevPaidin / prev_paidin) * 1000)) / 10;

				} else {
					comparePrevIncome = total_income;
					comparePrevPrepay = total_prepay;
					comparePrevPaidin = total_paidin;
					
					percent_income = 100.0f;
					percent_prepay = 100.0f;
					percent_paidin = 100.0f;
				}
			}
			((TextView) v.findViewById(R.id.biztotal)).setText("￥" + total);
			
		/*	float total_paidin_bank = 0.0f;//实收银行
			float total_paidin_cash = 0.0f;//实收现金
			float service_cash = 0.0f;//服务现金
			float service_bank = 0.0f;//服务银行
			float product_cash = 0.0f;//卖品现金
			float product_bank = 0.0f;//卖品银行
			float card = 0.0f;//划卡
			float newcard_cash = 0.0f;//开卡现金
			float newcard_bank = 0.0f;//开卡银行
			float rechargecard_cash = 0.0f;//充值现金
			float rechargecard_bank = 0.0f;//充值银行
*/			
			String total_paidin_bank = incomeperformance.getTotal_paidin_bank() == null ? "0.0"
					: incomeperformance.getTotal_paidin_bank();
			String total_paidin_cash =incomeperformance.getTotal_paidin_bank() == null ? "0.0"
					: incomeperformance.getTotal_paidin_bank();
			
			String service_cash = incomeperformance.getService_cash() == null ? "0.0"
					: incomeperformance.getService_cash();
			String service_bank = incomeperformance.getService_bank() == null ? "0.0"
					: incomeperformance.getService_bank();
			
			String product_cash = incomeperformance.getProduct_cash() == null ? "0.0"
					: incomeperformance.getProduct_cash();
			String product_bank = incomeperformance.getProduct_bank() == null ? "0.0"
					: incomeperformance.getProduct_bank();
			
			String newcard_cash = incomeperformance.getNewcard_cash() == null ? "0.0"
					: incomeperformance.getNewcard_cash();
			String newcard_bank = incomeperformance.getNewcard_bank() == null ? "0.0"
					: incomeperformance.getNewcard_bank();
			
			String rechargecard_cash = incomeperformance.getRechargecard_cash() == null ? "0.0"
					: incomeperformance.getRechargecard_cash();
			String rechargecard_bank = incomeperformance.getRechargecard_bank() == null ? "0.0"
					: incomeperformance.getRechargecard_bank();
			
			String card = incomeperformance.getCard() == null ? "0.0"
					: incomeperformance.getCard();
			
			
			/*((TextView) v.findViewById(R.id.sevicedata)).setText("￥"
					+ (float) (Math.round(Float.valueOf(sevicedata) * 10)) / 10);
			((TextView) v.findViewById(R.id.saledata)).setText("￥"
					+ (float) (Math.round(Float.valueOf(saledata) * 10)) / 10);
			((TextView) v.findViewById(R.id.carddata)).setText("￥"
					+ (float) (Math.round(Float.valueOf(carddata) * 10)) / 10);
			((TextView) v.findViewById(R.id.rechargedata)).setText("￥"
					+ (float) (Math.round(Float.valueOf(rechargedata) * 10)) / 10);*/

			((TextView) v.findViewById(R.id.sevicedata))
					.setTextColor(context.getResources().getColor(R.color.gray_text));
			((TextView) v.findViewById(R.id.saledata)).setTextColor(context.getResources()
					.getColor(R.color.gray_text));
			((TextView) v.findViewById(R.id.carddata)).setTextColor(context.getResources()
					.getColor(R.color.gray_text));
			((TextView) v.findViewById(R.id.rechargedata))
					.setTextColor(context.getResources().getColor(R.color.gray_text));

			((ImageView) v.findViewById(R.id.sevicesicon))
					.setImageResource(R.drawable.down);
			((ImageView) v.findViewById(R.id.saleicon))
					.setImageResource(R.drawable.down);
			((ImageView) v.findViewById(R.id.cardicon))
					.setImageResource(R.drawable.down);
			((ImageView) v.findViewById(R.id.rechargeicon))
					.setImageResource(R.drawable.down);

			/*comparePrevNewcard = (float) (Math.round(Float
					.valueOf(comparePrevNewcard) * 10)) / 10;
			comparePrevRecharge = (float) (Math.round(Float
					.valueOf(comparePrevRecharge) * 10)) / 10;
			comparePrevService = (float) (Math.round(Float
					.valueOf(comparePrevService) * 10)) / 10;
			comparePrevProduct = (float) (Math.round(Float
					.valueOf(comparePrevProduct) * 10)) / 10;
			((TextView) v.findViewById(R.id.toprev_sevicedata)).setText("比上"
					+ timetype.getText().toString() + ": " + comparePrevService
					+ " " + showPercent(percent_service) + "%");
			((TextView) v.findViewById(R.id.toprev_saledata)).setText("比上"
					+ timetype.getText().toString() + ": " + comparePrevProduct
					+ " " + showPercent(percent_product) + "%");
			((TextView) v.findViewById(R.id.toprev_carddata)).setText("比上"
					+ timetype.getText().toString() + ": " + comparePrevNewcard
					+ " " + showPercent(percent_newcard) + "%");
			((TextView) v.findViewById(R.id.toprev_rechargedata)).setText("比上"
					+ timetype.getText().toString() + ": " + comparePrevRecharge
					+ " " + showPercent(percent_recharge) + "%");

			if (comparePrevService > 0.0) {
				((ImageView) v.findViewById(R.id.sevicesicon))
						.setImageResource(R.drawable.up);
				((TextView) v.findViewById(R.id.sevicedata))
						.setTextColor(context.getResources().getColor(R.color.orange_bg));
			}

			if (comparePrevProduct > 0.0) {
				((ImageView) v.findViewById(R.id.saleicon))
						.setImageResource(R.drawable.up);
				((TextView) v.findViewById(R.id.saledata))
						.setTextColor(context.getResources().getColor(R.color.orange_bg));
			}

			if (comparePrevNewcard > 0.0) {
				((ImageView) v.findViewById(R.id.cardicon))
						.setImageResource(R.drawable.up);
				((TextView) v.findViewById(R.id.carddata))
						.setTextColor(context.getResources().getColor(R.color.orange_bg));
			}

			if (comparePrevRecharge > 0.0) {
				((ImageView) v.findViewById(R.id.rechargeicon))
						.setImageResource(R.drawable.up);
				((TextView) v.findViewById(R.id.rechargedata))
						.setTextColor(context.getResources().getColor(R.color.orange_bg));
			}

			newcard = (float) (Math.round(newcard * 1000)) / 10;
			recharge = (float) (Math.round(recharge * 1000)) / 10;
			service = (float) (Math.round(service * 1000)) / 10;
			product = (float) (Math.round(product * 1000)) / 10;
			*/
			float incomePercent[] = { 50.0f, 15.0f, 5.0f };
			float performancePercent[] = { 15.0f, 15.0f };
			LinearLayout annularLayout = (LinearLayout) v.findViewById(R.id.income_annularLayout);
			annularLayout.removeAllViews();
			IncomePerChartView panelDountView = new IncomePerChartView(
					context, incomePercent, performancePercent);
			annularLayout.addView(panelDountView);
		}
		
		public String showPercent(float percent) {
			if (percent > 0.0f) {
				return "+" + percent;
			}

			return String.valueOf(percent);
		}
}
