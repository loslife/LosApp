package com.yilos.losapp;

import android.os.Bundle;  
import android.annotation.SuppressLint;  
import android.app.Activity;  
import android.content.Context;  
import android.content.res.Resources;  
import android.graphics.BlurMaskFilter;  
import android.graphics.Canvas;  
import android.graphics.Color;  
import android.graphics.Paint;  
import android.graphics.Path;  
import android.graphics.Typeface;  
import android.graphics.Path.Direction;  
import android.graphics.RectF;  
import android.util.DisplayMetrics;  
import android.view.Menu;  
import android.view.View; 

public class PanelBar extends View {
	 private int ScrHeight;  
     private int ScrWidth;  
                       
     private Paint[] arrPaintArc;  
     private Paint PaintText = null;       
       
     final int[] colors = new int[]{           
             R.color.vone,  
             R.color.vtwo,  
             R.color.vthree,  
             R.color.vgeneral,  
             R.color.blue,                 
         };  
       
     //饼图演示用的比例,实际使用中，即为外部传入的比例参数  
     final float arrPer[] = new float[]{20f,30f,10f,40f};  
       
     //柱形图演示用的比例,实际使用中，即为外部传入的比例参数  
     private  int[] arrNum = null;  
       
     @SuppressLint("NewApi")
	public PanelBar(Context context,int[] num){  
         super(context);  
           
         //解决4.1版本 以下canvas.drawTextOnPath()不显示问题              
         this.setLayerType(View.LAYER_TYPE_SOFTWARE,null);  
           
         //屏幕信息  
         DisplayMetrics dm = getResources().getDisplayMetrics();  
         ScrHeight = dm.heightPixels;  
         ScrWidth = dm.widthPixels;  
         arrNum =  num;         
      
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
         PaintText.setColor(Color.GRAY);  
         PaintText.setTextSize(30);  
         PaintText.setTypeface(Typeface.DEFAULT_BOLD);  
     }  
       
     public void onDraw(Canvas canvas){  
         //画布背景  
         canvas.drawColor(Color.WHITE);      
           
         arrPaintArc[3].setTextSize(40);  
           
         int i= 0;         
           
         int lnWidth = 0; //标识线宽度  
         int lnSpace = 60; //标识间距  
           
         int startx = 120;  
         int endx = startx + 20;  
           
         int starty = 350;  
         int endy = 270;  
           
         int initX = startx;  
         int initY = starty;  
           
         int rectHeight = 40; //柱形框高度  
           
   
         /////////////////////////  
         //横向柱形图  
         ///////////////////////////  
         /*startx = 120;// ScrWidth / 2 - 50;  
         endx = startx + 20;  
           
         starty = ScrHeight - ScrHeight / 3 ;  
         endy = ScrHeight - ScrHeight / 3 ;  */
           
         initX = startx;  
         initY = starty;  
           
         // Y 轴  传入参数及柱形  
         for(i=0; i<arrNum.length; i++)   
         {                 
             starty =  initY - (i+1) * lnSpace; //起始线要提高一位  
             endy = starty-rectHeight;  
               
             canvas.drawLine( startx - lnWidth  ,starty  ,initX,endy , PaintText);
             
             //文字 偏移30，下移10  
             canvas.drawText("￥"+Integer.toString(arrNum[i]), initX + (Float.valueOf(arrNum[i]) /200) * lnSpace+50,endy+40, arrPaintArc[3]);
             
             Paint  paint = null;
             if(i<3)
             {
                 paint =  arrPaintArc[i];
             }
             else
             {
            	 paint = arrPaintArc[3];
             }
             //柱形  
             canvas.drawRect(initX   ,endy,  
                         initX + (Float.valueOf(arrNum[i]) /200) * lnSpace ,endy+rectHeight, paint);    
                            
         }  
         //canvas.drawLine( startx ,starty - 30 ,initX ,initY , PaintText);  
         // Y 轴  
         canvas.drawLine( startx ,ScrHeight-300,initX ,70, PaintText);  
            
         // X 轴 刻度与标识                  
         for(i=0; i< 6 ; i++)   
         {                          
             startx=  initX + (i+1) * lnSpace;  
             endx = startx;  
             //canvas.drawLine( startx  ,initY ,startx ,initY + lnSpace, PaintText);  
             //canvas.drawLine( startx  ,initY ,startx ,endy, PaintText);  
             //文字右移10位  
             //canvas.drawText(Integer.toString(i + 1), startx - 10,initY + lnSpace, PaintText);                         
         }  
         // X 轴            
         //canvas.drawLine( initX ,initY  ,ScrWidth - 10  ,initY, PaintText);  
           
           
     }         
 }  


