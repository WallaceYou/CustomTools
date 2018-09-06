//
//  ViewController.m
//  test
//
//  Created by youyu on 2018/4/20.
//  Copyright © 2018年 youyu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "SecondViewController.h"
#import "UIButton+Custom.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn2 = [UIButton buttonWithTitle:@"嘻嘻" titleColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:16] buttonBgColor:[UIColor greenColor]];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor cyanColor];
//    view.frame = CGRectMake(0, 0, 100, 0);//这种也行
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
    }];
    
    self.cusView.backgroundColor = [UIColor yellowColor];
    self.navigationBarHidden = YES;
    
    self.navigationBarView.rightBarButtonItems = @[btn2,view];
    
    self.navigationBarHeight = 100;
    
    self.bottomViewHidden = NO;//只在iPhone X有效果
    
    UILabel *label = [UILabel new];
    label.text = @"label";
    label.textColor = [UIColor blackColor];
    [self.cusView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];
    
    UIButton *showBtn = [UIButton buttonWithTitle:@"显示隐藏导航" titleColor:[UIColor blueColor] textFont:[UIFont systemFontOfSize:16] buttonBgColor:[UIColor grayColor]];
    [showBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.cusView addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
    }];
    
    UIButton *pushBtn = [UIButton buttonWithTitle:@"push" titleColor:[UIColor blueColor] textFont:[UIFont systemFontOfSize:16] buttonBgColor:[UIColor grayColor]];
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.cusView addSubview:pushBtn];
    [pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    
    
    
}


- (void)show {
    self.navigationBarHidden = !self.navigationBarHidden;
//    self.navigationBarHeight = 150;
//    SecondViewController *vc = [SecondViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//    self.bottomViewHidden = !self.bottomViewHidden;
}

- (void)push {
    self.navigationBarHeight = 150;
    SecondViewController *vc = [SecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    self.bottomViewHidden = !self.bottomViewHidden;
}



@end
