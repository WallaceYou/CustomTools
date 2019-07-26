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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这句话是设置MBProgressHUD的样式，有两种，一种是以前版本的经典黑色样式，另一种是现在版本的白色样式，一般这句话写在AppDelegate中，如果不写则默认为以前的黑色样式
    //[MBProgressHUD setMBProgressHUDType:MBProgressHUDTypeWhite];
    
}


- (IBAction)buttonClick:(id)sender {
    
    //一、显示progress一般使用的几种方式，可以打开代码注释一一尝试看看效果
    //1、不希望用户点击屏幕任何位置，即遮盖整个窗口则使用：
    //[MBProgressHUD showProgressOnWindow];
    //[MBProgressHUD showProgressOnWindowText:@""];
    
    /** 使用最多 */
    //2、遮盖住当前View的所有部分，但不遮盖导航栏的点击，则使用如下两种：（因为如果全部遮盖，返回键都按不了了，用户体验太差，给人一种卡死的感觉）
    //[MBProgressHUD showProgressOnCurrentView];
    //[MBProgressHUD showProgressOnCurrentViewText:@"加载中"];
    
    //3、不遮盖任何部分，即页面的任何地方可以照常点击（不建议使用）
    //[MBProgressHUD showProgressOnCurrentViewCoverScope:MBProgressHUDCoverScopeNone];
    //[MBProgressHUD showProgressOnCurrentViewCoverScope:MBProgressHUDCoverScopeNone text:@""];
    
    //4、如果不是将Progress加在当前View，而是某个View上，则可以使用：
    //[MBProgressHUD showProgressOnView:];
    //[MBProgressHUD showProgressOnView: text:];
    //[MBProgressHUD showProgressOnView: coverScope:];
    //[MBProgressHUD showProgressOnView: coverScope: text:]
    
    //5、另外还可以加Y轴偏移量
    //[MBProgressHUD showProgressOnCurrentViewCoverScope: text: offsetY:];
    //[MBProgressHUD showProgressOnView: coverScope: text: offsetY:];
    
    
    
    
    //二、显示message的几种方式
    /** 使用最多 */
    //1、不遮盖屏幕任何位置，即哪里都可以正常点击
    //[MBProgressHUD showMessage:@"登录成功"];
    
    //2、不希望用户点击屏幕任何位置，即遮盖整个窗口
    //[MBProgressHUD showMessage:@"登录成功" coverScope:MBProgressHUDCoverScopeView];
    
    
    
    
    //三、显示正确信息和显示错误信息和上面使用方法一样
    //1、不遮盖屏幕任何位置，即哪里都可以正常点击
    //[MBProgressHUD showSuccess:@"登录成功"];
    [MBProgressHUD showError:@"登录失败"];
    
    //2、不希望用户点击屏幕任何位置，即遮盖整个窗口
    //[MBProgressHUD showSuccess:@"登录成功" coverScope:MBProgressHUDCoverScopeView];
    //[MBProgressHUD showError:@"登录失败" coverScope:MBProgressHUDCoverScopeView];
    
}

- (IBAction)hideClick:(id)sender {
    //无论哪种，都可以使用这句来隐藏
    [MBProgressHUD hideHUD];
}


@end
