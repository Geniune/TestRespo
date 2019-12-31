//
//  ZXLineChart.m
//  LFLineChart
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "ZXLineChart.h"
#import "ZXView.h"

@interface ZXLineChart ()

@property (nonatomic, strong) ZXView *zxView;

@end

@implementation ZXLineChart

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGBHex(0xFFFFFF);
        [self setupHeadView];
        [self setupZXView];
    }
    return self;
}

- (void)setupHeadView{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, APP_W - 30.0f, 13.0f)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"一周价格走势（点击图中圆点可查看当日价格）"];
    //设置字体大小
    [attributedString addAttribute:NSFontAttributeName value:FontPingFangSC_Regular(13) range:NSMakeRange(0, 6)];
    [attributedString addAttribute:NSFontAttributeName value:FontPingFangSC_Regular(12) range:NSMakeRange(6, 15)];
    //设置字体颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:NSMakeRange(0,6)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBHex(0x999999) range:NSMakeRange(6, 15)];
    label.attributedText = attributedString;
    
    [self addSubview:label];
}

- (void)setupZXView{
    
    _zxView = [[ZXView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 300)];
    [self addSubview:_zxView];
}

- (void)setItemArr:(NSArray *)itemArr{
    
    [_zxView mapping:itemArr];
}

@end
