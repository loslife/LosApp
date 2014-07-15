package com.yilos.losapp;

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
     
     private String[] name = null;
     
     float numSpace = 0.0f;
       
     //饼图演示用的比例,实际使用中，即为外部传入的比例参数  
     final float arrPer[] = new float[]{20f,30f,10f,40f};  
       
     //柱形图演示用的比例,实际使用中，即为外部传入的比例参数  
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
         numSpace = Float.valueOf(arrNum[0])/5;
      
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
         //画布背景  
         canvas.drawColor(Color.WHITE);      
           
         arrPaintArc[3].setTextSize(40);  
           
         int i= 0;         
           
         int lnWidth = 0; //标识线宽度  
         int lnSpace = 65; //标识间距  
           
         int startx = 200;  
         int endx = startx + 20;  
           
         int starty = 320;  
         int endy = 280;  
           
         int initX = startx;  
         int initY = starty;  
           
         int rectHeight = 50; //柱形框高度  
           
   
         /////////////////////////  
         //横向柱形图  
         ///////////////////////////  
         
           
         // Y 轴  传入参数及柱形  
         for(i=0; i<arrNum.length; i++)   
         {                 
             starty =  70 + i* lnSpace; //起始线要提高一位  
             endy = starty-rectHeight;  
               
             
             //文字 偏移30，下移10  
             canvas.drawText("￥"+arrNum[i], initX + (Float.valueOf(arrNum[i]) /numSpace) * lnSpace+10,endy+40, arrPaintArc[3]);
             
             canvas.drawText(name[i], initX-name[i].length()*40,endy+40, arrPaintArc[3]);
             
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
                         initX + (Float.valueOf(arrNum[i]) /numSpace) * lnSpace ,endy+rectHeight, paint);    
                            
         }  
         //canvas.drawLine( startx ,starty - 30 ,initX ,initY , PaintText);  
         // Y 轴  
         canvas.drawLine( startx ,ScrHeight-350,initX ,30, PaintText);  
            
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


