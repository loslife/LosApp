package com.yilos.secretary.pulldown;


import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ScrollView;

/**
 * @author wangxiao1@cjsc.com.cn
 * @date 2013-7-9
 * 
 */
public class PullDownScrollView extends LinearLayout {

    private static final String TAG = "PullDownScrollView";

    private int refreshTargetTop = -60;
    private int headContentHeight;

    private RefreshListener refreshListener;

    private RotateAnimation animation;
    private RotateAnimation reverseAnimation;
    
    private final static int RATIO = 2;
    private int preY = 0;
    private boolean isElastic = false;
    private int startY;
    private int state;
    
    private String note_release_to_refresh = "�ɿ�����";
    private String note_pull_to_refresh = "����ˢ��";
    private String note_refreshing = "���ڸ���...";
    
    private IPullDownElastic mElastic;
    

    public PullDownScrollView(Context context) {
        super(context);
        init();

    }

    public PullDownScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        animation = new RotateAnimation(0, -180,
                RotateAnimation.RELATIVE_TO_SELF, 0.5f,
                RotateAnimation.RELATIVE_TO_SELF, 0.5f);
        animation.setInterpolator(new LinearInterpolator());
        animation.setDuration(250);
        animation.setFillAfter(true);

        reverseAnimation = new RotateAnimation(-180, 0,
                RotateAnimation.RELATIVE_TO_SELF, 0.5f,
                RotateAnimation.RELATIVE_TO_SELF, 0.5f);
        reverseAnimation.setInterpolator(new LinearInterpolator());
        reverseAnimation.setDuration(200);
        reverseAnimation.setFillAfter(true);
    }
    /**
     * @param listener
     */
    public void setRefreshListener(RefreshListener listener) {
        this.refreshListener = listener;
    }
    /**
     * @param elastic
     */
    public void setPullDownElastic(IPullDownElastic elastic) {
        mElastic = elastic;
        
        headContentHeight = mElastic.getElasticHeight();
        refreshTargetTop = - headContentHeight;
        LayoutParams lp = new LinearLayout.LayoutParams(
                LayoutParams.FILL_PARENT, headContentHeight);
        lp.topMargin = refreshTargetTop;
        addView(mElastic.getElasticLayout(), 0, lp);
    }
    
 
    public void setRefreshTips(String pullToRefresh, String releaseToRefresh, String refreshing) {
        note_pull_to_refresh = pullToRefresh;
        note_release_to_refresh = releaseToRefresh;
        note_refreshing = refreshing;
    }
    /*
     * 
     * @see
     * android.view.ViewGroup#onInterceptTouchEvent(android.view.MotionEvent)
     */
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        printMotionEvent(ev);
        if (ev.getAction() == MotionEvent.ACTION_DOWN) {
            preY = (int) ev.getY();
        }
        if (ev.getAction() == MotionEvent.ACTION_MOVE) {

            if (!isElastic && canScroll()
                    && (int) ev.getY() - preY >= headContentHeight / (3*RATIO)
                    && refreshListener != null && mElastic != null) {

                isElastic = true;
                startY = (int) ev.getY();
                return true;
            }

        }
        return super.onInterceptTouchEvent(ev);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        printMotionEvent(event);
        handleHeadElastic(event);
        return super.onTouchEvent(event);
    }

    private void handleHeadElastic(MotionEvent event) {
        if (refreshListener != null && mElastic != null) {
            switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                break;
            case MotionEvent.ACTION_UP:

                if (state != IPullDownElastic.REFRESHING && isElastic) {
                    
                    if (state == IPullDownElastic.DONE) {
                        setMargin(refreshTargetTop);
                    }
                    if (state == IPullDownElastic.PULL_To_REFRESH) {
                        state = IPullDownElastic.DONE;
                        setMargin(refreshTargetTop);
                        changeHeaderViewByState(state, false);
                    }
                    if (state == IPullDownElastic.RELEASE_To_REFRESH) {
                        state = IPullDownElastic.REFRESHING;
                        setMargin(0);
                        changeHeaderViewByState(state, false);
                        onRefresh();
                    }

                }
                isElastic = false;
                break;
            case MotionEvent.ACTION_MOVE:
                int tempY = (int) event.getY();
                
                if (state != IPullDownElastic.REFRESHING && isElastic) {
                    if (state == IPullDownElastic.RELEASE_To_REFRESH) {
                        if (((tempY - startY) / RATIO < headContentHeight)
                                && (tempY - startY) > 0) {
                            state = IPullDownElastic.PULL_To_REFRESH;
                            changeHeaderViewByState(state, true);
                        } else if (tempY - startY <= 0) {
                            state = IPullDownElastic.DONE;
                            changeHeaderViewByState(state, false);
                        }
                    }
                    if (state == IPullDownElastic.DONE) {
                        if (tempY - startY > 0) {
                            state = IPullDownElastic.PULL_To_REFRESH;
                            changeHeaderViewByState(state, false);
                        }
                    }
                    if (state == IPullDownElastic.PULL_To_REFRESH) {
                        // ���������Խ���RELEASE_TO_REFRESH��״̬
                        if ((tempY - startY) / RATIO >= headContentHeight) {
                            state = IPullDownElastic.RELEASE_To_REFRESH;
                            changeHeaderViewByState(state, false);
                        } else if (tempY - startY <= 0) {
                            state = IPullDownElastic.DONE;
                            changeHeaderViewByState(state, false);
                        }
                    }
                    if (tempY - startY > 0) {
                        setMargin((tempY - startY)/2 + refreshTargetTop);
                    }
                }
                break;
            }
        }
    }
    
    /**
     * 
     */
    private void setMargin(int top) {
        LinearLayout.LayoutParams lp = (LayoutParams) mElastic.getElasticLayout()
                .getLayoutParams();
        lp.topMargin = top;
        mElastic.getElasticLayout().setLayoutParams(lp);
        mElastic.getElasticLayout().invalidate();
    }

    private void changeHeaderViewByState(int state, boolean isBack) {

        mElastic.changeElasticState(state, isBack);
        switch (state) {
        case IPullDownElastic.RELEASE_To_REFRESH:
            mElastic.showArrow(View.VISIBLE);
            mElastic.showProgressBar(View.GONE);
            mElastic.showLastUpdate(View.VISIBLE);
            mElastic.setTips(note_release_to_refresh);

            mElastic.clearAnimation();
            mElastic.startAnimation(animation);
            break;
        case IPullDownElastic.PULL_To_REFRESH:
            mElastic.showArrow(View.VISIBLE);
            mElastic.showProgressBar(View.GONE);
            mElastic.showLastUpdate(View.VISIBLE);
            mElastic.setTips(note_pull_to_refresh);

            mElastic.clearAnimation();

            if (isBack) {
                mElastic.startAnimation(reverseAnimation);
            }
            break;
        case IPullDownElastic.REFRESHING:
            mElastic.showArrow(View.GONE);
            mElastic.showProgressBar(View.VISIBLE);
            mElastic.showLastUpdate(View.GONE);
            mElastic.setTips(note_refreshing);

            mElastic.clearAnimation();
            break;
        case IPullDownElastic.DONE:
            mElastic.showProgressBar(View.GONE);
            mElastic.clearAnimation();
            break;
        }
    }

    private void onRefresh() {
        // downTextView.setVisibility(View.GONE);
//        scroller.startScroll(0, i, 0, 0 - i);
//        invalidate();
        if (refreshListener != null) {
            refreshListener.onRefresh(this);
        }
    }

    /**
     * 
     */
    @Override
    public void computeScroll() {
//        if (scroller.computeScrollOffset()) {
//            int i = this.scroller.getCurrY();
//            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) this.refreshView
//                    .getLayoutParams();
//            int k = Math.max(i, refreshTargetTop);
//            lp.topMargin = k;
//            this.refreshView.setLayoutParams(lp);
//            this.refreshView.invalidate();
//            invalidate();
//        }
    }

    /**
     */
    public void finishRefresh(String text) {
        if (mElastic == null) {
            return;
        }
        if (state == IPullDownElastic.DONE) {
        }
        state = IPullDownElastic.DONE;
        if (text != null) {
            mElastic.setLastUpdateText(text);
        }
        changeHeaderViewByState(state,false);

        mElastic.showArrow(View.VISIBLE);
        mElastic.showLastUpdate(View.VISIBLE);
        setMargin(refreshTargetTop);
//        scroller.startScroll(0, i, 0, refreshTargetTop);
//        invalidate();
    }

    private boolean canScroll() {
        View childView;
        if (getChildCount() > 1) {
            childView = this.getChildAt(1);
            if (childView instanceof AbsListView) {
                int top = ((AbsListView) childView).getChildAt(0).getTop();
                int pad = ((AbsListView) childView).getListPaddingTop();
                if ((Math.abs(top - pad)) < 3
                        && ((AbsListView) childView).getFirstVisiblePosition() == 0) {
                    return true;
                } else {
                    return false;
                }
            } else if (childView instanceof ScrollView) {
                if (((ScrollView) childView).getScrollY() == 0) {
                    return true;
                } else {
                    return false;
                }
            }

        }
        return canScroll(this);
    }
    
    /**
     * @param view
     * @return
     */
    public boolean canScroll(PullDownScrollView view) {
        return false;
    }

    private void printMotionEvent(MotionEvent event) {
        switch (event.getAction()) {
        case MotionEvent.ACTION_DOWN:
            break;
        case MotionEvent.ACTION_MOVE:
            break;
        case MotionEvent.ACTION_UP:
        default:
            break;
        }
    }
    /**
     */
    public interface RefreshListener {
        public void onRefresh(PullDownScrollView view);
    }

}
