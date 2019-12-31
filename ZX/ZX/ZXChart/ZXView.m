//
//  ZXView.m
//  LFLineChart
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "ZXView.h"
#import "ZXPointView.h"
#import "ZXModel.h"

#define BoundWidth APP_W - 75
#define PreWidth 50
#define BoundHeight PreWidth * 5

@interface ZXView ( ){
    
    UIView *statusView;
    ZXPointView *selectedPointView;
    CAShapeLayer *selectedX;
    CAShapeLayer *selectedY;
    
    NSArray *modelArr;
}

@property (nonatomic, strong) CAShapeLayer *lineChartLayer;
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) UIView *backgroundView;


@end

@implementation ZXView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        [self createLabelY];
    }
    return self;
}

- (void)drawGradientBackgroundView {
    //背景视图
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(52, 52, BoundWidth, BoundHeight)];
    self.backgroundView.backgroundColor = RGBHex(0xFFFFFF);
    [self addSubview:self.backgroundView];
}

- (void)setLineDash{
    
    //x轴
    for(NSInteger i = 0;i < 6;i ++){
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, i * PreWidth)];
        [path addLineToPoint:CGPointMake(PreWidth * (modelArr.count - 1) + 5, i * PreWidth)];
    
        CAShapeLayer *dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = RGBHex(0xf2f2f2).CGColor;
        dashLayer.fillColor = nil;
        dashLayer.lineWidth = 0.5f;
        dashLayer.path = path.CGPath;
    
        [self.backgroundView.layer addSublayer:dashLayer];
    }
    
    //y轴
    for(NSInteger i = 0;i < modelArr.count;i ++){

        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(i * PreWidth + 5,BoundHeight)];
        [path addLineToPoint:CGPointMake(i * PreWidth + 5, 0)];

        CAShapeLayer *dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = RGBHex(0xf2f2f2).CGColor;
        dashLayer.fillColor = nil;
        dashLayer.lineWidth = 0.5f;
        dashLayer.path = path.CGPath;

        [self.backgroundView.layer addSublayer:dashLayer];
    }
}

- (void)mapping:(NSArray *)pointArr{
    
    modelArr = pointArr;
    [self dravLine:pointArr];
}

- (void)dravLine:(NSArray *)arr{
    
    [self drawGradientBackgroundView];
    [self setLineDash];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    for(int i=0;i < arr.count;i ++){
        
        ZXModel *model = arr[i];
        
        //TODO:算法优化
        CGFloat Y = BoundHeight * ((5000 - [model.count floatValue]) / 5000);
        
        if(i == 0){
            
            [path moveToPoint:CGPointMake(5, Y)];
            [self addPointView:CGPointMake(5, Y) index:0];
            continue;
        }
        [path addLineToPoint:CGPointMake(PreWidth*i + 5, Y)];
        [self addPointView:CGPointMake(PreWidth*i + 5, Y) index:i];
    }
    
    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = PointColor.CGColor;
    dashLayer.fillColor = nil;
    dashLayer.lineWidth = 1.0f;
    dashLayer.path = path.CGPath;
    
    [self.backgroundView.layer addSublayer:dashLayer];
    
    [self drawGradient:path];
}

#pragma mark 渐变阴影
- (void)drawGradient:(UIBezierPath *)path{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.colors = @[(__bridge id)RGBAHex(0x5494FF, 0.2f).CGColor, (__bridge id)RGBAHex(0x5494FF, 0.2f).CGColor];
    
    gradientLayer.locations=@[@1.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint = CGPointMake(0,1);
    
    [path addLineToPoint:CGPointMake(PreWidth * (modelArr.count - 1) + 5, BoundHeight)];
    [path addLineToPoint:CGPointMake(5, BoundHeight)];
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = path.CGPath;
    gradientLayer.mask = arc;
    [self.backgroundView.layer addSublayer:gradientLayer];
}

- (void)addPointView:(CGPoint)point index:(NSInteger)index{
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    pointView.tag = index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [pointView addGestureRecognizer:tap];
    
    UIView *pointV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    pointV.layer.cornerRadius = 2.5f;
    pointV.backgroundColor = PointColor;
    pointV.center = pointView.center;
    [pointView addSubview:pointV];
    
     pointView.center = point;
    [self.backgroundView addSubview:pointView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint point = tap.view.center;
    
    if(selectedX){
        [selectedX removeFromSuperlayer];
    }
    if(selectedY){
        [selectedY removeFromSuperlayer];
    }
    if(selectedPointView){
        [selectedPointView removeFromSuperview];
    }
    if(statusView){
        [statusView removeFromSuperview];
    }
    
    selectedX = [self addShapeX:point];
    selectedY = [self addShapeY:point];
    selectedPointView = [self addShapePoint:point];
    
    ZXModel *model = modelArr[tap.view.tag];
    
    //TODO:展示当日价格、涨幅
    NSLog(@"%@当前价格：%@", model.item, model.count);
    
    [self addStatusView:model point:point];
}

- (void)addStatusView:(ZXModel *)model point:(CGPoint)point{
    
    if(!statusView){
        statusView = [[UIView alloc] init];
    }
    for(UIView *view in statusView.subviews){
        [view removeFromSuperview];
    }
    
    NSString *priceStr = model.count;
    NSString *statusStr = @"+0.36%";
    
    CGSize priceSize = [self sizeText:priceStr font:FontPingFangSC_Regular(12) limitHeight:12];
    CGSize statusSize = [self sizeText:statusStr font:FontPingFangSC_Regular(12) limitHeight:12];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, priceSize.width, 12.0f)];
    priceLabel.text = priceStr;
    priceLabel.textColor = XYColor;
    priceLabel.font = FontPingFangSC_Regular(12);
    [statusView addSubview:priceLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceSize.width + 20, 0, statusSize.width, 12.0f)];
    statusLabel.font = FontPingFangSC_Regular(12);
    statusLabel.text = statusStr;
    statusLabel.textColor = XYColor;
    [statusView addSubview:statusLabel];
    
    statusView.frame = CGRectMake(point.x - priceSize.width - 10, point.y - 18, priceSize.width + statusSize.width + 20, 12.0f);
    [self.backgroundView addSubview:statusView];
}

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.height=height;
    rect.size.width=ceil(rect.size.width);
    return rect.size;
}

- (ZXPointView *)addShapePoint:(CGPoint)point{
    
    ZXPointView *pointView = [[ZXPointView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    pointView.center = point;
    [self.backgroundView addSubview:pointView];
    
    
    return pointView;
}

- (CAShapeLayer *)addShapeX:(CGPoint)point{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, point.y)];
    [path addLineToPoint:CGPointMake(PreWidth * (modelArr.count - 1) + 5, point.y)];
    
    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = XYColor.CGColor;
    dashLayer.fillColor = nil;
    dashLayer.lineWidth = 0.5f;
    dashLayer.path = path.CGPath;
    
    [self.backgroundView.layer addSublayer:dashLayer];
    
    return dashLayer;
}

- (CAShapeLayer *)addShapeY:(CGPoint)point{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(point.x, 0)];
    [path addLineToPoint:CGPointMake(point.x, PreWidth * 5)];
    
    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = XYColor.CGColor;
    dashLayer.fillColor = nil;
    dashLayer.lineWidth = 0.5f;
    dashLayer.path = path.CGPath;
    
    [self.backgroundView.layer addSublayer:dashLayer];
    
    return dashLayer;
}

- (void)createLabelY{

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 27, 20)];
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = FontPingFangSC_Regular(kFontS0);
    label1.textColor = RGBHex(0x999999);
    label1.text = @"5000";
    [self addSubview:label1];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 92, 27, 20)];
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = FontPingFangSC_Regular(kFontS0);
    label2.textColor = RGBHex(0x999999);
    label2.text = @"4000";
    [self addSubview:label2];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 142, 27, 20)];
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = FontPingFangSC_Regular(kFontS0);
    label3.textColor = RGBHex(0x999999);
    label3.text = @"3000";
    [self addSubview:label3];

    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 192, 27, 20)];
    label4.textAlignment = NSTextAlignmentRight;
    label4.font = FontPingFangSC_Regular(kFontS0);
    label4.textColor = RGBHex(0x999999);
    label4.text = @"2000";
    [self addSubview:label4];

    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 242, 27, 20)];
    label5.textAlignment = NSTextAlignmentRight;
    label5.font = FontPingFangSC_Regular(kFontS0);
    label5.textColor = RGBHex(0x999999);
    label5.text = @"1000";
    [self addSubview:label5];

    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(10, 292, 27, 20)];
    label6.textAlignment = NSTextAlignmentRight;
    label6.font = FontPingFangSC_Regular(kFontS0);
    label6.textColor = RGBHex(0x999999);
    label6.text = @"0";
    [self addSubview:label6];
}

- (void)setXArr:(NSArray *)array{
    
    CGFloat Y = BoundHeight + 62;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(57, Y, 32, 12)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = FontPingFangSC_Regular(kFontS0);
    label1.textColor = RGBHex(0x999999);
    label1.text = @"12-01";
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(57 + PreWidth * 3 - 16, Y, 32, 12)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = FontPingFangSC_Regular(kFontS0);
    label2.textColor = RGBHex(0x999999);
    label2.text = @"12-04";
    [self addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(57 + PreWidth * 6 - 32, Y, 32, 12)];
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = FontPingFangSC_Regular(kFontS0);
    label3.textColor = RGBHex(0x999999);
    label3.text = @"12-07";
    [self addSubview:label3];
}

@end
