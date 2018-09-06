//
//  SecondViewController.m
//  test
//
//  Created by youyu on 2018/4/23.
//  Copyright © 2018年 youyu. All rights reserved.
//

#import "SecondViewController.h"
#import "Masonry.h"
#import "PresentViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
//    self.navigationBarHidden = YES;
    self.navigationBarView.textLabel.text = @"你好";
    
    UIButton *bb = [UIButton buttonWithType:UIButtonTypeCustom];
    [bb setTitle:@"adsf" forState:UIControlStateNormal];
    [bb setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bb addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
    [self.cusView addSubview:bb];
    [bb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
}

- (void)haha {
//        self.navigationBarHidden = YES;
//        self.navigationBarHeight = 150;
    PresentViewController *vc = [PresentViewController new];

    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:navi animated:YES completion:nil];
    self.bottomViewHidden = YES;
}


@end
