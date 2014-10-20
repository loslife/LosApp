package com.yilos.secretary.common;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ListView;
import android.widget.SectionIndexer;
import android.widget.TextView;

public class SideBar extends View {
	private char[] l;
	private SectionIndexer sectionIndexter = null;
	private ListView list;
	private TextView mDialogText;
	Paint paint = new Paint();

	public SideBar(Context context) {
		super(context);
		init();
	}

	public SideBar(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	private void init() {
		l = new char[] { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
				'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
				'X', 'Y', 'Z' ,'#'};
	}

	public SideBar(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init();
	}

	public void setListView(ListView _list) {
		list = _list;
		sectionIndexter = (SectionIndexer) _list.getAdapter();
	}

	public void setTextView(TextView mDialogText) {
		this.mDialogText = mDialogText;
	}

	public boolean onTouchEvent(MotionEvent event) {
		super.onTouchEvent(event);
		int i = (int) event.getY();
		int singleHeight = getMeasuredHeight() / l.length;
		int idx = i / singleHeight;
		if (idx >= l.length) {
			idx = l.length - 1;
		} else if (idx < 0) {
			idx = 0;
		}
		if (event.getAction() == MotionEvent.ACTION_DOWN
				|| event.getAction() == MotionEvent.ACTION_MOVE) {
			mDialogText.setVisibility(View.VISIBLE);
			mDialogText.setText("" + l[idx]);
			if (sectionIndexter == null) {
				sectionIndexter = (SectionIndexer) list.getAdapter();
			}
			int position = sectionIndexter.getPositionForSection(l[idx]);
			if (position == -1) {
				return true;
			}
			list.setSelection(position);
		} else {
			mDialogText.setVisibility(View.INVISIBLE);
		}
		return true;
	}

	protected void onDraw(Canvas canvas) {

		paint.setColor(0xff595c61);
		paint.setTextSize(18);
		paint.setTextAlign(Paint.Align.CENTER);
		paint.setTextScaleX(2.0f);
		paint.setAntiAlias(true);

		float widthCenter = getMeasuredWidth() / 2;
		int singleHeight = getMeasuredHeight() / l.length;

		for (int i = 0; i < l.length; i++) {
			float yPos = getMeasuredHeight() * i + getMeasuredHeight();
			canvas.drawText(String.valueOf(l[i]), widthCenter, singleHeight
					+ (i * singleHeight), paint);
		}
		super.onDraw(canvas);
	}
}
