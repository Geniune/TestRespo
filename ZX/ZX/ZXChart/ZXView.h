//
//  ZXView.h
//  LFLineChart
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZXView : UIView

- (void)setXArr:(NSArray *)array;
- (void)mapping:(NSArray *)pointArr;//绘制折线图

@end
