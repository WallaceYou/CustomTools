//
//  CustomNavigationBar.h
//  KuGe
//
//  Created by yuyou on 2018/6/8.
//  Copyright © 2018年 YuYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface CustomNavigationBar : UIView

/** 导航栏底部线是否隐藏 */
@property (nonatomic, assign) BOOL naviBottomLineHidden;

/** 导航栏左边的按钮数组 */
@property (nonatomic, strong) NSArray *leftBarButtonItems;

/** 导航栏中间的视图 */
@property (nonatomic, strong) UIView *titleView;

/** 导航栏中间的textLabel */
@property (nonatomic, strong) UILabel *textLabel;

/** 导航栏中间的title */
@property (nonatomic, copy) NSString *title;

/** 导航栏右边的按钮数组 */
@property (nonatomic, strong) NSArray *rightBarButtonItems;

@end
