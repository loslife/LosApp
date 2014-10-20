package com.yilos.secretary.common;


import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.widget.Scroller;

public class ScrollLayout extends ViewGroup 
{

	private static final String TAG = "ScrollLayout";
	private Scroller mScroller;
	private VelocityTracker mVelocityTracker;
	private int mCurScreen;
	private int mDefaultScreen = 0;
	private static final int TOUCH_STATE_REST = 0;
	private static final int TOUCH_STATE_SCROLLING = 1;
	private static final int SNAP_VELOCITY = 600;
	private int mTouchState = TOUCH_STATE_REST;
	private int mTouchSlop;
	private float mLastMotionX;
	private float mLastMotionY;
	private float mLastRawX;
	private float mLastRawY;
    private OnViewChangeListener mOnViewChangeListener;

    /**
     * 设置是否可左右滑动
     * @author liux
     */
    private boolean isScroll = true;
    public void setIsScroll(boolean b) {
    	this.isScroll = b;
    }
    
	public ScrollLayout(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	public ScrollLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		mScroller = new Scroller(context);
		mCurScreen = mDefaultScreen;
		mTouchSlop = ViewConfiguration.get(getContext()).getScaledTouchSlop();
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {
		int childLeft = 0;
		final int childCount = getChildCount();
		for (int i = 0; i < childCount; i++) {
			final View childView = getChildAt(i);
			if (childView.getVisibility() != View.GONE) {
				final int childWidth = childView.getMeasuredWidth();
				childView.layout(childLeft, 0, childLeft + childWidth,
						childView.getMeasuredHeight());
				childLeft += childWidth;
			}
		}
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		//Log.e(TAG, "onMeasure");
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		final int width = MeasureSpec.getSize(widthMeasureSpec);
		final int widthMode = MeasureSpec.getMode(widthMeasureSpec);
		if (widthMode != MeasureSpec.EXACTLY) {
			throw new IllegalStateException(
					"ScrollLayout only canmCurScreen run at EXACTLY mode!");
		}
		/*final int heightMode = MeasureSpec.getMode(heightMeasureSpec);
		if (heightMode != MeasureSpec.EXACTLY) {
			throw new IllegalStateException(
					"ScrollLayout only can run at EXACTLY mode!");
		}*/

		// The children are given the same width and height as the scrollLayout
		final int count = getChildCount();
		for (int i = 0; i < count; i++) {
			getChildAt(i).measure(widthMeasureSpec, heightMeasureSpec);
		}
		// Log.e(TAG, "moving to screen "+mCurScreen);
		scrollTo(mCurScreen * width, 0);
	}

	/**
	 * According to the position of current layout scroll to the destination
	 * page.
	 */
	public void snapToDestination() {
		final int screenWidth = getWidth();
		final int destScreen = (getScrollX() + screenWidth / 2) / screenWidth;
		snapToScreen(destScreen);
	}

	public void snapToScreen(int whichScreen) {
		//是否可滑动
		if(!isScroll) {
			this.setToScreen(whichScreen);
			return;
		}
		
		scrollToScreen(whichScreen);
	}

	public void scrollToScreen(int whichScreen) {		
		// get the valid layout page
		whichScreen = Math.max(0, Math.min(whichScreen, getChildCount() - 1));
		if (getScrollX() != (whichScreen * getWidth())) {
			final int delta = whichScreen * getWidth() - getScrollX();
			mScroller.startScroll(getScrollX(), 0, delta, 0,
					Math.abs(delta) * 1);//持续滚动时间 以毫秒为单位
			mCurScreen = whichScreen;
			invalidate(); // Redraw the layout
            
			if (mOnViewChangeListener != null)
            {
            	mOnViewChangeListener.OnViewChange(mCurScreen);
            }
		}
	}
	
	public void setToScreen(int whichScreen) {
		whichScreen = Math.max(0, Math.min(whichScreen, getChildCount() - 1));
		mCurScreen = whichScreen;
		scrollTo(whichScreen * getWidth(), 0);
		
        if (mOnViewChangeListener != null)
        {
        	mOnViewChangeListener.OnViewChange(mCurScreen);
        }
	}

	public int getCurScreen() {
		return mCurScreen;
	}

	@Override
	public void computeScroll() {
		if (mScroller.computeScrollOffset()) {
			scrollTo(mScroller.getCurrX(), mScroller.getCurrY());
			postInvalidate();
		}
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		//是否可滑动
		if(!isScroll) {
			return false;
		}
		
		if (mVelocityTracker == null) {
			mVelocityTracker = VelocityTracker.obtain();
		}
		mVelocityTracker.addMovement(event);
		final int action = event.getAction();
		final float x = event.getX();
		final float y = event.getY();
		float lastyDiff = event.getY();
		switch (action) {
		case MotionEvent.ACTION_DOWN:
			Log.i(TAG, "event down!");
			if (!mScroller.isFinished()) {
				mScroller.abortAnimation();
			}
			mLastMotionX = x;
			
			//---------------New Code----------------------
			mLastMotionY = y;
			//---------------------------------------------
			
			break;
		case MotionEvent.ACTION_MOVE:
			Log.i(TAG, "event move!");
			
			int deltaX = (int) (mLastMotionX - x);
			
			//---------------New Code----------------------
			int deltaY = (int) (mLastMotionY - y);
			   Log.i(TAG, "ScrollLayout ACTION_MOVE ===========Math.abs(deltaX)= :"+Math.abs(deltaX)+" Math.abs(deltaY) :"+Math.abs(deltaY));
			   //10-11 12:03:52.176: I/ScrollLayout(3423): ScrollLayout ACTION_MOVE ===========Math.abs(deltaX)= :6 Math.abs(deltaY) :14
			lastyDiff = Math.abs(deltaX);
			if(Math.abs(deltaX) < 200 && Math.abs(deltaY) >=3)
				break;
			mLastMotionY = y;
			mLastMotionX = x;
			  
		    scrollBy(deltaX, 0);   
			break;
		case MotionEvent.ACTION_UP:
			Log.i(TAG, "event up!");
			mLastMotionY = y;
			mLastMotionX = x;
			// if (mTouchState == TOUCH_STATE_SCROLLING) {
			final VelocityTracker velocityTracker = mVelocityTracker;
			velocityTracker.computeCurrentVelocity(1000);
			int velocityX = (int) velocityTracker.getXVelocity();
			
			Log.i(TAG, "ScrollLayout ACTION_UP ===========velocityX= :"+velocityX);
			if (velocityX > SNAP_VELOCITY && mCurScreen > 0) {
				// Fling enough to move left
				//Log.e(TAG, "snap left");
				snapToScreen(mCurScreen - 1);
			} else if (velocityX < -SNAP_VELOCITY
					&& mCurScreen < getChildCount() - 1) {
				// Fling enough to move right
				//Log.e(TAG, "snap right");
				snapToScreen(mCurScreen + 1);
			} else {
				snapToDestination();
			}
			if (mVelocityTracker != null) {
				mVelocityTracker.recycle();
				mVelocityTracker = null;
			}
			// }
			mTouchState = TOUCH_STATE_REST;
			break;
		case MotionEvent.ACTION_CANCEL:
			mTouchState = TOUCH_STATE_REST;
			break;
		}
		return true;
	}

	@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		final int action = ev.getAction();
		if ((action == MotionEvent.ACTION_MOVE)
				&& (mTouchState != TOUCH_STATE_REST)) {
			return true;
		}
		final float x = ev.getX();
		final float y = ev.getY();
		int rawy = (int) ev.getRawY();
        int rawx =  (int) ev.getRawX();
		switch (action) {
		case MotionEvent.ACTION_MOVE:
			
			final int xDiff = (int) Math.abs(mLastMotionX - x);
			final int yDiff = (int) Math.abs(mLastMotionY - y);
			final int xRaw= (int) Math.abs(mLastRawX - rawx);
			final int yRaw = (int) (mLastRawY - rawy);
			double z=Math.sqrt(xDiff*xDiff+yDiff*yDiff);
            int jiaodu=Math.round((float)(Math.asin(yDiff/z)/Math.PI*180));//角度
            
            Log.i(TAG, "ScrollLayout ACTION_MOVE ===========jiaodu= :"+jiaodu+ " xDiff ："+xDiff+"  yDiff :"+yDiff);
            Log.i(TAG, "ScrollLayout ACTION_MOVE ===========:"+ " xRaw ："+xRaw+"  yRaw :"+yRaw);
            Log.i(TAG, "ScrollLayout ACTION_MOVE ===========:"+ " mLastMotionX ："+mLastMotionX+"  x :"+x);
            Log.i(TAG, "ScrollLayout ACTION_MOVE ===========:"+ " mLastMotiony ："+mLastMotionY+"  y :"+y);
            //增加角度
			if (xDiff>3&&jiaodu<=30) {
				mTouchState = TOUCH_STATE_SCROLLING;
			}
			
			break;
		case MotionEvent.ACTION_DOWN:
			mLastMotionX = x;
			mLastMotionY = y;
			mLastRawX = rawx;
			mLastRawY = rawy;
			mTouchState = mScroller.isFinished() ? TOUCH_STATE_REST
					: TOUCH_STATE_SCROLLING;
			break;
		case MotionEvent.ACTION_CANCEL:
		case MotionEvent.ACTION_UP:
			mTouchState = TOUCH_STATE_REST;
			break;
		}
		return mTouchState != TOUCH_STATE_REST;
	}
	
	/**
	 * 设置屏幕切换监听器
	 * @param listener
	 */
	public void SetOnViewChangeListener(OnViewChangeListener listener)
	{
		mOnViewChangeListener = listener;
	}

	/**
	 * 屏幕切换监听器
	 * @author liux
	 */
	public interface OnViewChangeListener {
		public void OnViewChange(int view);
	}

}      