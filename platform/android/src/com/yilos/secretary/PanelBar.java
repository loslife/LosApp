package com.yilos.secretary;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.BlurMaskFilter;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.util.DisplayMetrics;
import android.view.View;

public class PanelBar extends View {
	 DisplayMetrics dm = getResources().getDisplayMetrics();
	 private int ScrHeight;  
     private int ScrWidth;  
     
     private int yLength;
                       
     private Paint[] arrPaintArc;  
     private Paint PaintText = null;       
       
     final int[] colors = new int[]{           
             R.color.vone,  
             R.color.vtwo,  
             R.color.vthree,  
             R.color.vgeneral,  
             R.color.blue,                 
         };  
     
     private String[] name = null;
     
     float numSpace = 0.0f;
       
     final float arrPer[] = new float[]{20f,30f,10f,40f};  
       
     //柱形
     private  String[] arrNum = null;  
     
     @SuppressLint("NewApi")
	public PanelBar(Context context,String[] num,String[] ename){  
         super(context); 

           
         //解决4.1版本 以下canvas.drawTextOnPath()不显示问题              
         this.setLayerType(View.LAYER_TYPE_SOFTWARE,null);  
           
         //屏幕信息  
         DisplayMetrics dm = getResources().getDisplayMetrics();  
         ScrHeight = dm.heightPixels;  
         ScrWidth = dm.widthPixels;  
         arrNum =  num; 
         name = ename;
         if(arrNum.length>0)
         {
        	 numSpace = Float.valueOf(arrNum[0])/5; 
         }
         
      
         //设置边缘特殊效果  
         BlurMaskFilter PaintBGBlur = new BlurMaskFilter(  
                                 1, BlurMaskFilter.Blur.INNER);  

         arrPaintArc = new Paint[5];   
         Resources res = this.getResources();  
         for(int i=0;i<5;i++)  
         {  
             arrPaintArc[i] = new Paint();             
             arrPaintArc[i].setColor(res.getColor(colors[i] ));   
               
             arrPaintArc[i].setStyle(Paint.Style.FILL);  
             arrPaintArc[i].setStrokeWidth(4);  
             arrPaintArc[i].setMaskFilter(PaintBGBlur);  
         }  
               
         PaintText = new Paint();  
         PaintText.setColor((res.getColor(colors[3])));  
         PaintText.setTextSize(30);  
         PaintText.setTypeface(Typeface.DEFAULT_BOLD);  
     }  
       
     public void onDraw(Canvas canvas){  
    	 Resources res = this.getResources();
         //画布背景  
         canvas.drawColor(Color.WHITE);      
           
         arrPaintArc[3].setTextSize(getResources().getDimension(R.dimen.Text_size_m));  
           
         int i= 0;         
           
         int lnWidth = 0; //标识线宽度  
         int lnSpace = ScrHeight/15; //标识间距  
           
         int startx = ScrWidth/5;  
         int endx = startx + 20;  
           
         int starty = 500;  
         int endy = 100*arrNum.length;  
           
         int initX = startx;  
         int initY = starty;  
           
         int rectHeight = ScrHeight/20; //柱形框高度 

         /////////////////////////  
         //横向柱形图  
         ///////////////////////////  
         
         boolean fff = true;  
         // Y 轴  传入参数及柱形  
         for(i=0; i<arrNum.length; i++)   
         {                 
             starty =  lnSpace+ i* lnSpace; //起始线要提高一位  
             endy = starty-rectHeight;  

             //文字 偏移，下移10  
             arrPaintArc[3].setColor(res.getColor(R.color.gray_text));   
             canvas.drawText("￥"+(float) (Math.round(Float.valueOf(arrNum[i])* 10)) / 10, initX + (Float.valueOf(arrNum[i]) /numSpace) * (lnSpace-20)+10,endy+40, arrPaintArc[3]);
             
             canvas.drawText(name[i], rectHeight/2,endy+50, arrPaintArc[3]);
             
             Paint  paint = null;
             if(i<3)
             {
                 paint =  arrPaintArc[i];
             }
             else
             {
            	 arrPaintArc[3].setColor(res.getColor(colors[3] ));   
            	 paint = arrPaintArc[3];
             }
             //柱形  
             canvas.drawRect(initX   ,endy,  
                         initX + (Float.valueOf(arrNum[i]) /numSpace) * (lnSpace-20),endy+rectHeight, paint);    
                            
         }  
         //canvas.drawLine( startx ,starty - 30 ,initX ,initY , PaintText);  
         // Y 轴  
         if(arrNum.length>0)
         {
        	 canvas.drawLine( startx ,starty,initX ,lnSpace-rectHeight, PaintText);  
         }
         
            
         // X 轴 刻度与标识                  
         for(i=0; i< 6 ; i++)   
         {                          
             startx=  initX + (i+1) * lnSpace;  
             endx = startx;                      
         }  
         // X 轴            
         //canvas.drawLine( initX ,initY  ,ScrWidth - 10  ,initY, PaintText);  
     }
     
   @Override
 	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
	   DisplayMetrics dm = getResources().getDisplayMetrics();
 		setMeasuredDimension(dm.widthPixels, arrNum.length*(dm.heightPixels/15)+20);
 	}
 }  


