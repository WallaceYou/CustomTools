//
//  CustomNavigationBarController.h
//  Mu
//
//  Created by youyu on 17/5/9.
//  Copyright © 2017年 yuyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"

@interface CustomNavigationBarController : UIViewController

/** 代替self.navigationController.navigationBar的视图 */
@property (nonatomic, strong) CustomNavigationBar *navigationBarView;

/** 代替self.view的视图 */
@property (nonatomic, strong) UIView *cusView;

/** 代表本控制器是否隐藏导航栏 */
@property (nonatomic, assign) BOOL navigationBarHidden;

/** 导航栏的高度 */
@property (nonatomic, assign) CGFloat navigationBarHeight;

/** 适配iPhone X的bottomView是否隐藏（有些时候就需要全屏显示，比如整张图片或者h5的网页） */
@property (nonatomic, assign) BOOL bottomViewHidden;

@end
