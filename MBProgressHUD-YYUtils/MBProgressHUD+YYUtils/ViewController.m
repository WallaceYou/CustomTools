//
//  ViewController.m
//  MBProgressHUD+YYUtils
//
//  Created by 游宇的Macbook on 2018/5/20.
//  Copyright © 2018年 YuYou. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+YYUtils.h"

@interface ViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [MBProgressHUD setMBProgressHUDType:MBProgressHUDTypeWhite];
    
}


- (IBAction)buttonClick:(id)sender {
    

    [MBProgressHUD showError:@"网络好像有点问题哦" coverScope:MBProgressHUDCoverScopeView];
//    [MBProgressHUD showMessage:@"网络好像有点问题哦" coverScope:MBProgressHUDCoverScopeView];
//    [MBProgressHUD showProgressOnCurrentViewCoverScope:MBProgressHUDCoverScopeNone text:@"gaga" offsetY:50];
    
}

- (IBAction)hideClick:(id)sender {
    [MBProgressHUD hideHUD];
}


@end
