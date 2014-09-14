package com.yilos.secretary.view;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.BizPerformanceBean;
import com.yilos.secretary.chartview.ServiceGoodsChartView;

public class BizPerformanceView {
	

	// 绘制服务业绩
	public void setBizPerformanceChartView(Context context,View v, TextView timetype,
			BizPerformanceBean bizPerformance,
			BizPerformanceBean prevBizPerformance) {
		
		float newcard = 0.0f;
		float recharge = 0.0f;
		float service = 0.0f;
		float product = 0.0f;
		float total = 0.0f;

		float comparePrevNewcard = 0.0f;
		float comparePrevRecharge = 0.0f;
		float comparePrevService = 0.0f;
		float comparePrevProduct = 0.0f;

		float prev_newcard = 0.0f;
		float prev_recharge = 0.0f;
		float prev_service = 0.0f;
		float prev_product = 0.0f;

		float percent_newcard = 0.0f;
		float percent_recharge = 0.0f;
		float percent_service = 0.0f;
		float percent_product = 0.0f;

		if (bizPerformance.getTotal() == null
				|| Float.valueOf(bizPerformance.getTotal()) == 0.0f) {
			((LinearLayout) v.findViewById(R.id.business_empty))
					.setVisibility(View.VISIBLE);
			((LinearLayout) v.findViewById(R.id.annularLayout))
			.setVisibility(View.GONE);
			((View) v.findViewById(R.id.midview))
			.setVisibility(View.GONE);
			((LinearLayout) v.findViewById(R.id.performacncetext))
			.setVisibility(View.GONE);
			((TextView) v.findViewById(R.id.biztotal)).setText("￥0.0");
			
			return;
		} else {
			((LinearLayout) v.findViewById(R.id.business_empty))
					.setVisibility(View.GONE);
			((LinearLayout) v.findViewById(R.id.annularLayout))
			.setVisibility(View.VISIBLE);
			((View) v.findViewById(R.id.midview))
			.setVisibility(View.VISIBLE);
			((LinearLayout) v.findViewById(R.id.performacncetext))
			.setVisibility(View.VISIBLE);
		}

		if (null != bizPerformance.get_id()) {
			// newcard":13000,"recharge":10,"service":1900,"product":200
			newcard = Float.valueOf(bizPerformance.getNewcard())
					/ Float.valueOf(bizPerformance.getTotal());
			recharge = Float.valueOf(bizPerformance.getRecharge())
					/ Float.valueOf(bizPerformance.getTotal());
			service = Float.valueOf(bizPerformance.getService())
					/ Float.valueOf(bizPerformance.getTotal());
			product = Float.valueOf(bizPerformance.getProduct())
					/ Float.valueOf(bizPerformance.getTotal());
			total = Float.valueOf(bizPerformance.getTotal());
			total = (float) (Math.round(total * 10)) / 10;
			if (null != prevBizPerformance.get_id()) {
				prev_newcard = Float.valueOf(prevBizPerformance.getNewcard());
				comparePrevNewcard = Float.valueOf(bizPerformance.getNewcard())
						- prev_newcard;
				prev_recharge = Float.valueOf(prevBizPerformance.getRecharge());
				comparePrevRecharge = Float.valueOf(bizPerformance
						.getRecharge()) - prev_recharge;
				prev_service = Float.valueOf(prevBizPerformance.getService());
				comparePrevService = Float.valueOf(bizPerformance.getService())
						- prev_service;
				prev_product = Float.valueOf(prevBizPerformance.getProduct());
				comparePrevProduct = Float.valueOf(bizPerformance.getProduct())
						- prev_product;

				percent_newcard = (Math
						.round((comparePrevNewcard / prev_newcard) * 1000)) / 10;
				if (!(prev_newcard > 0)) {
					percent_newcard = +100.0f;
				}
				percent_recharge = (Math
						.round((comparePrevRecharge / prev_recharge) * 1000)) / 10;
				if (!(prev_recharge > 0)) {
					percent_recharge = +100.0f;
				}
				percent_service = (Math
						.round((comparePrevService / prev_service) * 1000)) / 10;
				if (!(prev_service > 0)) {
					percent_service = +100.0f;
				}
				percent_product = (Math
						.round((comparePrevProduct / prev_product) * 1000)) / 10;
				if (!(prev_product > 0)) {
					percent_product = +100.0f;
				}
			} else {
				comparePrevNewcard = Float.valueOf(bizPerformance.getNewcard());
				comparePrevRecharge = Float.valueOf(bizPerformance
						.getRecharge());
				comparePrevService = Float.valueOf(bizPerformance.getService());
				comparePrevProduct = Float.valueOf(bizPerformance.getProduct());

				percent_newcard = 100.0f;
				percent_recharge = 100.0f;
				percent_service = 100.0f;
				percent_product = 100.0f;
			}
		}

		String sevicedata = bizPerformance.getService() == null ? "0.0"
				: bizPerformance.getService();
		String saledata = bizPerformance.getProduct() == null ? "0.0"
				: bizPerformance.getProduct();
		String carddata = bizPerformance.getNewcard() == null ? "0.0"
				: bizPerformance.getNewcard();
		String rechargedata = bizPerformance.getRecharge() == null ? "0.0"
				: bizPerformance.getRecharge();
		((TextView) v.findViewById(R.id.biztotal)).setText("￥" + total);
		((TextView) v.findViewById(R.id.sevicedata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(sevicedata) * 10)) / 10);
		((TextView) v.findViewById(R.id.saledata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(saledata) * 10)) / 10);
		((TextView) v.findViewById(R.id.carddata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(carddata) * 10)) / 10);
		((TextView) v.findViewById(R.id.rechargedata)).setText("￥"
				+ (float) (Math.round(Float.valueOf(rechargedata) * 10)) / 10);

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

		comparePrevNewcard = (float) (Math.round(Float
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

		String[] perName = { "开卡业绩", "充值业绩", "服务业绩", "卖品业绩" };

		// 环形图
		float[] num2 = new float[] { newcard, recharge, service, product };
		LinearLayout annularLayout = (LinearLayout) v.findViewById(R.id.annularLayout);
		annularLayout.removeAllViews();
		ServiceGoodsChartView panelDountView = new ServiceGoodsChartView(
				context, num2, perName, "business");
		annularLayout.addView(panelDountView);
	}
	
	public String showPercent(float percent) {
		if (percent > 0.0f) {
			return "+" + percent;
		}

		return String.valueOf(percent);
	}

}
