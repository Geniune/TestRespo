//
//  ZXPointView.m
//  LFLineChart
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "ZXPointView.h"

@interface ZXPointView ()

@end

@implementation ZXPointView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();//获得当前栈顶
    //画白底
    CGContextSetFillColorWithColor(context, RGBHex(0xFFFFFF).CGColor);//填充颜色
    CGContextAddArc(context, 10, 10, RADIUS, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    
    //画边框
    CGContextSetStrokeColorWithColor(context, PointColor.CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, 10, 10, RADIUS, 0, 2*M_PI, 0);//添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
    
    //画圆
    CGContextSetFillColorWithColor(context, PointColor.CGColor);//填充颜色
    CGContextAddArc(context, 10, 10, SRADIUS, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    
}

@end


