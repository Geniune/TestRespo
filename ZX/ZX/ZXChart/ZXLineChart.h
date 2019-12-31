//
//  ZXLineChart.h
//  LFLineChart
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXModel.h"

@interface ZXLineChart : UIView

@property (nonatomic, strong) NSArray *itemArr;

/**
 *  Y轴最大值
 */
@property (nonatomic, assign) CGFloat maxValue;

@end
