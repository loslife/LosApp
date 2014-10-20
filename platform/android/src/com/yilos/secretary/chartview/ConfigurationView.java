package com.yilos.secretary.chartview;

import com.yilos.secretary.Main;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.TextView;

public class ConfigurationView extends View {
	private Paint paint;
	private Paint font_Paint;
	// 数值显示的偏移量
	private int numWidth = 9;
	// 起始高度为 最大高度减去 80 【注意这里的高度是反的，也就是说，y轴是逐渐减少的】
	private float startHeight = Main.HEIGHT + 50;
	private float endHeight = startHeight;
	// 柱状图的宽度
	private int viewWidth = 20;
	// 组态图的高度 【显示的数值，100 为 100%】
	private int maxSize = 43;
	private int indexSize = 0;
	// 要显示的模式 【类型，比如：℃和百分比等】
	private String displayMode = "%";
	// 模式
	private boolean mode = false;
	// 线程控制
	private boolean display = true;
	// 是否开启动画效果
	private boolean animMode = true;

	/**
	 * 
	 * @param context
	 * @param maxSize
	 *            需要显示的数值
	 * @param displayMode
	 *            显示的类型
	 */
	public ConfigurationView(Context context, int maxSize, String displayMode) {
		super(context);
		this.maxSize = maxSize;
		this.displayMode = displayMode;
		init();
	}

	/**
	 * 
	 * @param context
	 * @param maxSize
	 *            需要显示的数值
	 * @param displayMode
	 *            显示的类型
	 * @param mode
	 *            显示的模式，默认为false，数值越高，颜色越偏向红色。为true反之
	 */
	public ConfigurationView(Context context, int maxSize, String displayMode,
			boolean mode) {
		super(context);
		this.maxSize = maxSize;
		this.displayMode = displayMode;
		this.mode = mode;
		init();
	}

	/**
	 * 
	 * @param context
	 * @param maxSize
	 *            需要显示的数值
	 * @param displayMode
	 *            显示的类型
	 * @param mode
	 *            显示的模式，默认为false，数值越高，颜色越偏向红色。为true反之
	 * @param animMode
	 *            是否显示动画加载效果，默认为true
	 */
	public ConfigurationView(Context context, int maxSize, String displayMode,
			boolean mode, boolean animMode) {
		super(context);
		this.maxSize = maxSize;
		this.displayMode = displayMode;
		this.mode = mode;
		this.animMode = animMode;
		init();
	}

	// 绘制界面
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		canvas.drawText("画矩形：", 10, 80, font_Paint);  
		paint.setColor(Color.RED);// 设置灰色  
		paint.setStyle(Paint.Style.FILL);//设置填满  
        canvas.drawRect(60, 90, 160, 100, paint);// 长方形
	}

	// 初始化
	private void init() {
		// 数值初始化
		paint = new Paint();
		paint.setARGB(255, 110, 210, 20);
		font_Paint = new Paint();
		font_Paint.setARGB(255, 66, 66, 66);
		// 设置顶端数值显示的偏移量，数值越小，偏移量越大
		numWidth = 9;
		if (maxSize < 10) {
			numWidth = 15;
		} else if (maxSize < 100) {
			numWidth = 12;
		}
		if (animMode) {
			// 启动一个线程来实现柱状图缓慢增高
			thread.start();
		} else {
			// 不启用动画效果，则直接赋值进行绘制
			display = false;
			indexSize = maxSize;
			endHeight = startHeight - (float) (maxSize * 1.5);
			invalidate();
		}
	}

	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			// 通过endHeight >= 20将柱状图的高度控制在150以内，这样刚好循环一百次到顶部
			if (msg.what == 1 && indexSize < maxSize && endHeight >= 20) {
				endHeight -= 1.5;
				indexSize += 1;
			} else {
				display = false;
			}
			invalidate();
		}
	};
	private Thread thread = new Thread() {
		@Override
		public void run() {
			while (!Thread.currentThread().isInterrupted() && display) {
				Message msg = new Message();
				msg.what = 1;
				handler.sendMessage(msg);
				try {
					// 每隔15毫秒触发，尽量使升高的效果看起来平滑
					Thread.sleep(15);
				} catch (InterruptedException e) {
					System.err.println("InterruptedException！线程关闭");
					this.interrupt();
				}
			}
		}
	};
}
