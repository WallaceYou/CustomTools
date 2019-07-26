//
//  CustomNavigationBarController.m
//  Mu
//
//  Created by youyu on 17/5/9.
//  Copyright © 2017年 yuyou. All rights reserved.
//

#import "CustomNavigationBarController.h"
#import "CustomNavi.h"
//#import "LoginViewController.h"


/** 扩大按钮的点击区域 */
@interface ReturnButton : UIButton

@end

@implementation ReturnButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)even {
    
    CGRect bounds =self.bounds;
    
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    
    bounds =CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);//注意这里是负数，扩大了之前的bounds的范围
    
    return CGRectContainsPoint(bounds, point);
    
}

@end


@interface CustomNavigationBarController ()

/** 适配iPhone X的底部BottomView */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CustomNavigationBarController

#pragma mark - 以下两个方法可以防止调用不存在的方法而导致崩溃
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        signature = [NSString methodSignatureForSelector:@selector(stringWithFormat:)];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {}

#pragma mark - 初始化
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSubviews];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 视图加载

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self refreshNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //全局401跳登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToLoginPage) name:@"JumpToLoginPage" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomViewHidden = YES;//默认不适配底部bottom
    self.navigationBarHeight = kNavigationBarDefaultHeight;//默认导航栏为44
    [self setSubviews];
}

- (void)dealloc {
    NSLog(@"控制器被销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JumpToLoginPage" object:nil];
}

//设置在没有导航栏的情况下，状态栏内容为浅色
//- (UIStatusBarStyle) preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
    if (!self.navigationController) {
        // 如果没有navigationController，则将自定义的navigationBar移除掉
        [self.navigationBarView removeFromSuperview];
        self.navigationBarView = nil;
        [self.cusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        
        //设置bottomView的高度约束，不然cusView无法显示
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.bottomViewHidden?0:(self.tabBarController?kTabbar_Height:kBottomMargin));
        }];
    }
    
    
    BOOL hasUpper = self.isMovingToParentViewController;
    BOOL isPresenting = self.presentingViewController != nil;
    BOOL isPresented = self.presentedViewController != nil;
    
    //判断此页面是被pop还是push出来的
    if (hasUpper) {//此页面是被push，或者present，或者是根控制器
        
        if (isPresenting) {//如果当前页面是被present粗来的
            NSLog(@"此页面是被present出来的，加个返回按钮");
            [self addBackButton];
        } else {//否则是被push出来的或者根控制器
            if (self.navigationController.viewControllers.count > 1) {
                NSLog(@"此页面是被push出来的，加个返回按钮");
                [self addBackButton];
            } else {
                NSLog(@"此页面是根控制器");
            }
        }
        
        /* 因为self.tabBarController只有在viewWillAppear中才能知道是否有，所以在这里设置bottomView的高度约束 */
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.bottomViewHidden?0:(self.tabBarController?kTabbar_Height:kBottomMargin));
        }];
        
    } else {//此页面是pop，或者dismiss出来的
        
        if (isPresented) {
            NSLog(@"此页面是被dismiss出来的");
        } else {
            if (self.navigationController == nil || self.navigationController.viewControllers.count == 1) {
                NSLog(@"此页面是根控制器");
            } else {
                NSLog(@"此页面是被pop出来的");
            }
        }
    }
}

#pragma mark - 重写set方法
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    
    _navigationBarHidden = navigationBarHidden;
    
    [self.navigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationBarHidden?-(self.navigationBarHeight+kStatusBarHeight):0);
    }];
    
}

- (void)setNavigationBarHeight:(CGFloat)navigationBarHeight {
    
    _navigationBarHeight = navigationBarHeight;
    [self.view setNeedsLayout];
}

- (void)setBottomViewHidden:(BOOL)bottomViewHidden {
    _bottomViewHidden = bottomViewHidden;
    
    /* 更新高度约束 */
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.bottomViewHidden?0:(self.tabBarController?kTabbar_Height:kBottomMargin));
    }];
}

#pragma mark - 私有方法

- (void)setSubviews {
    
    self.navigationBarView = [CustomNavigationBar new];
    self.navigationBarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.8];
    
    self.cusView = [UIView new];
    self.cusView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    // 导航栏约束
    [self.view addSubview:self.navigationBarView];
    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarDefaultHeight+kStatusBarHeight);
    }];
    
    // bottomView约束
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
    // cusView约束
    [self.view addSubview:self.cusView];
    [self.cusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navigationBarView.mas_bottom).mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_equalTo(0);
    }];
}

// 刷新导航栏的显示（更新导航栏内部子视图约束）
- (void)refreshNavigationBarView {
    
    [self.navigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationBarHidden?-(self.navigationBarHeight+kStatusBarHeight):0);
        make.height.mas_equalTo((self.navigationBarHeight > 0?(self.navigationBarHeight+kStatusBarHeight):0));
    }];
    
}


- (void)addBackButton {
    ReturnButton *backBtn = [ReturnButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"blackback"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"blackback"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBarView.leftBarButtonItems = @[backBtn];
}


- (void)backBtnClick {
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/* 全局401跳转登陆页面 */
- (void)jumpToLoginPage {
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
//    [self presentViewController:navi animated:YES completion:nil];
}


@end
