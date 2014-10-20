package com.yilos.secretary;

import android.app.Activity;  
import android.graphics.Color;  
import android.os.Bundle;  
import android.view.Gravity;  
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;  
import android.view.Window;  
import android.view.WindowManager;
import android.widget.FrameLayout;  
import android.widget.LinearLayout;
import android.widget.TextView;  
  
public class LayerActivity extends Activity {  
  
    private LinearLayout layout = null;  
    private TextView textView = null;  
  
    public void onCreate(Bundle savedInstanceState) {  
        super.onCreate(savedInstanceState);  
        requestWindowFeature(Window.FEATURE_NO_TITLE);  
        setContentView(R.layout.mainlayer);  
  
        initViews();  
    }  
  
    private void initViews() {  
  
        layout = (LinearLayout) findViewById(R.id.layout);  
        textView = (TextView) findViewById(R.id.konw);
        
        textView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
			}
		});

        /*if(textView==null){  
            textView = new TextView(LayerActivity.this);  
            textView.setTextColor(Color.BLUE);  
            textView.setTextSize(20);  
            textView.setText("我知道了");  
            textView.setGravity(Gravity.CENTER);  
            textView.setLayoutParams(new ViewGroup.LayoutParams(  
                    ViewGroup.LayoutParams.FILL_PARENT,  
                    ViewGroup.LayoutParams.FILL_PARENT));  
            //textView.setBackgroundColor(Color.parseColor("#80858175"));
        }  
        layout.addView(textView);*/
    }  
   
}  