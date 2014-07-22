package com.yilos.losapp;

import com.yilos.losapp.common.ChartCalc;

import android.content.Context;  
import android.content.res.Resources;
import android.graphics.Canvas;  
import android.graphics.Color;  
import android.graphics.Paint;  
import android.graphics.RectF;  
import android.util.DisplayMetrics;  
import android.view.View;  
  
public class PanelDountChart extends View{  
      
    private int ScrWidth,ScrHeight;   
      
     //演示用的百分比例,实际使用中，即为外部传入的比例参数    
    private float arrPer[] = null;    
    //RGB颜色数组  
    private final int arrColorRgb[] = {  R.color.vone,  
            R.color.vtwo,  
            R.color.vthree,  
            R.color.vgeneral} ;  
    
   private  String strPer[] = null;
      
      
public PanelDountChart(Context context,float arr[],String textName[]) {  
        super(context);  
          
        //屏幕信息  
        DisplayMetrics dm = getResources().getDisplayMetrics();  
        ScrHeight = dm.heightPixels;  
        ScrWidth = dm.widthPixels; 
        this.arrPer = arr;
        this.strPer = textName;
    }  
  
      
    public void onDraw(Canvas canvas){  
        //画布背景  
        canvas.drawColor(Color.WHITE);                  
            
        float cirX = ScrWidth / 2;    
        float cirY = ScrHeight/ 8;    
        float radius = ScrWidth/6;//150;    
                                    
        float arcLeft = cirX - radius;    
        float arcTop  = cirY - radius ;    
        float arcRight = cirX + radius ;    
        float arcBottom = cirY + radius ;    
        RectF arcRF0 = new RectF(arcLeft ,arcTop,arcRight,arcBottom);     
          
        //画笔初始化  
        Paint PaintArc = new Paint();     
        PaintArc.setAntiAlias(true);  
          
        Paint PaintLabel = new Paint();
        PaintLabel.setColor(Color.GRAY);
        PaintLabel.setTextSize(36);        
           
        //位置计算类    
        ChartCalc xcalc = new ChartCalc();      
          
        float Percentage = 0.0f;  
        float CurrPer = 0.0f;  
        int i= 0;    
        for(i=0; i<arrPer.length; i++)     
        {    
            //将百分比转换为饼图显示角度    
            Percentage = 360 * (arrPer[i]/100);    
            Percentage = (float)(Math.round(Percentage *100))/100;    
            //分配颜色   
            Resources res = this.getResources();  
            PaintArc.setColor(res.getColor(arrColorRgb[i]));  
                 
            //在饼图中显示所占比例    
            canvas.drawArc(arcRF0, CurrPer, Percentage, true, PaintArc);                   
            //计算百分比标签  
            xcalc.CalcArcEndPointXY(cirX, cirY, radius - radius/2/2, CurrPer + Percentage/2); 
            
            float textX = 0.0f;
            float textY = 0.0f;
            if(xcalc.getPosX()>cirX)
            {
            	textX = xcalc.getPosX()+40;
            }
            else
            {
            	textX = xcalc.getPosX()-280;
            }
            
            if(xcalc.getPosY()>cirY)
            {
            	textY = xcalc.getPosY()+10;
            }
            else
            {
            	textY = xcalc.getPosY();
            }
            
            //标识  
            if(arrPer[i]!=0.0f)
            {
            	 canvas.drawText(strPer[i]+Float.toString(arrPer[i])+"%",textX, textY ,PaintLabel);    
            }
                     
            //下次的起始角度    
            CurrPer += Percentage;    
        }    
                           
        //画圆心  
        PaintArc.setColor(Color.WHITE);  
        canvas.drawCircle(cirX,cirY,radius*4/7,PaintArc);    
              
    }  
}