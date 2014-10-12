package com.yilos.secretary.adapter;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.yilos.secretary.R;
import com.yilos.secretary.bean.MemberBean;
import com.yilos.secretary.common.DateUtil;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.SectionIndexer;
import android.widget.TextView;

public class ListViewAdp extends BaseAdapter implements SectionIndexer {
	private Context mContext;
	private String[] members;
	static int i;
	static String[] first;
	List<MemberBean> memberData = new ArrayList<MemberBean>();

	public ListViewAdp(Context mContext, String[] parentData,List<MemberBean> memberList) {
		this.mContext = mContext;
		this.members = parentData;
		this.memberData = memberList;
	}

	@Override
	public int getCount() {
		return members.length;
	}

	@Override
	public Object getItem(int position) {
		return members[position];
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final String nickName = members[position];
		i = position;

		ViewHolder viewHolder = null;
		if (convertView == null) {
			convertView = LayoutInflater.from(mContext).inflate(
					R.layout.contact_item, null);
			viewHolder = new ViewHolder();
			viewHolder.tvCatalog = (TextView) convertView
					.findViewById(R.id.contactitem_catalog);
			viewHolder.tvNick = (TextView) convertView
					.findViewById(R.id.contactitem_nick);
			viewHolder.tvConsumeinfo = (TextView) convertView
					.findViewById(R.id.consumeinfo);
			viewHolder.membercards = (TextView) convertView
					.findViewById(R.id.membercards);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		String catalog = converterToFirstSpell(nickName).substring(0, 1);
		viewHolder.tvCatalog.setText(catalog);
		if (position == 0) {
			viewHolder.tvCatalog.setVisibility(View.VISIBLE);
			viewHolder.tvCatalog.setText(catalog);
		} else {
			String lastCatalog = converterToFirstSpell(members[position - 1])
					.substring(0, 1);
			if (catalog.equals(lastCatalog)) {
				viewHolder.tvCatalog.setVisibility(View.GONE);
			} else {
				viewHolder.tvCatalog.setVisibility(View.VISIBLE);
				viewHolder.tvCatalog.setText(catalog);
			}
		}

		// viewHolder.ivAvatar.setImageResource(R.drawable.default_avatar);
		int i = members[position].indexOf("|");
		viewHolder.tvNick.setText(members[position].substring(0, i));
		
		
		String p = members[position].substring(i + 1,
				members[position].length());
		
		//最后消费时间
		String latestConsumeTime = memberData.get(Integer.valueOf(p)).getLatestConsumeTime();
		//平均消费
		String averageConsume =  memberData.get(Integer.valueOf(p)).getAverageConsume();
		//会员卡
		String cards = memberData.get(Integer.valueOf(p)).getCardStr();
		
		if(null==latestConsumeTime||"".equals(latestConsumeTime))
		{
			latestConsumeTime = "未消费";
		}
		else
		{
			BigDecimal latestConsumeTimetr = new BigDecimal(latestConsumeTime); 
			latestConsumeTime = "最近消费"+DateUtil.dateToString(latestConsumeTimetr.toPlainString(),"yyyy年MM月dd日");
		}
		
		
		averageConsume = "平均消费"+(float) (Math.round(Float.valueOf(averageConsume) * 10)) / 10+"元";
		
		if(cards.length()>11)
		{
			cards = cards.substring(0, 11)+"...";
		}
		
		viewHolder.membercards.setText(cards);
		viewHolder.tvConsumeinfo.setText(latestConsumeTime+"/"+averageConsume);
		return convertView;
	}

	static class ViewHolder {
		TextView tvCatalog;
		// ImageView ivAvatar;
		TextView tvNick;
		
		TextView tvConsumeinfo;
		
		TextView membercards;
	}

	@Override
	public int getPositionForSection(int section) {
		for (int i = 0; i < members.length; i++) {
			String l = converterToFirstSpell(members[i]).substring(0, 1);
			char firstChar = l.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}
		return -1;
	}

	@Override
	public int getSectionForPosition(int position) {
		return 1;
	}

	@Override
	public Object[] getSections() {
		return null;
	}

	public static String converterToFirstSpell(String chines) {
		String pinyinName = "";
		char[] nameChar = chines.toCharArray();
		HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
		defaultFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);
		defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
		for (int i = 0; i < nameChar.length; i++) {
			if (!"".equals(nameChar[i])&&nameChar[i] > 128) {
				try {
					pinyinName += PinyinHelper.toHanyuPinyinStringArray(
							nameChar[i], defaultFormat)[0].charAt(0);
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
			} else {
				pinyinName += nameChar[i];
			}
			break;
		}
		return pinyinName;
	}
}
