//
//  ViewController.m
//  ZX
//
//  Created by Apple on 2018/5/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "ZXLineChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = RGBHex(0xF2F2F2);
    
    [self initView];
}

- (void)initView{
    
    ZXModel *model1 = [ZXModel new];
    model1.item = @"12-04";
    model1.count = @"4200";
    
    ZXModel *model2 = [ZXModel new];
    model2.item = @"12-05";
    model2.count = @"4000";
    
    ZXModel *model3 = [ZXModel new];
    model3.item = @"12-06";
    model3.count = @"3100";
    
    ZXModel *model4 = [ZXModel new];
    model4.item = @"12-07";
    model4.count = @"4000";
    
    ZXModel *model5 = [ZXModel new];
    model5.item = @"12-08";
    model5.count = @"3750";
    
    ZXModel *model6 = [ZXModel new];
    model6.item = @"12-09";
    model6.count = @"2300";
    
    ZXModel *model7 = [ZXModel new];
    model7.item = @"12-10";
    model7.count = @"3800";
    
    NSArray *array = @[model1, model2, model3, model4, model5, model6, model7];
    //    NSArray *array = @[model1, model2, model3, model4, model5];
    
    ZXLineChart *view = [[ZXLineChart alloc] initWithFrame:CGRectMake(0, 50, APP_W, 408.0f)];
    view.itemArr = array;
    view.maxValue = 5000;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
