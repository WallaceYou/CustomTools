//
//  CustomNavi.h
//  test
//
//  Created by yuyou on 2018/6/8.
//  Copyright © 2018年 youyu. All rights reserved.
//

#ifndef CustomNavi_h
#define CustomNavi_h

/* 屏幕尺寸 */
#define kWindowH [UIScreen mainScreen].bounds.size.height
#define kWindowW [UIScreen mainScreen].bounds.size.width


/* 以下几个宏是以4.7寸屏（iPhone6）为基准的屏幕比例 */
#define kIfHorizontal (kWindowW > kWindowH)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 利用屏幕高度的比值作为等倍率的参数，根据该比值放大宽度和高度
#define kScale (IS_IPAD?(kIfHorizontal?(kWindowW/667):(kWindowH/667)):(kIfHorizontal?(kWindowH/375):(kWindowW/375)))
#define kWidthScale (kIfHorizontal?(kWindowW/667):(kWindowW/375))
#define kHeightScale (kIfHorizontal?(kWindowH/375):(kWindowH/667))


/**
 iPhone X 适配相关
 */

// 是否是iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏默认高度
#define kNavigationBarDefaultHeight 44
// 导航栏高度
#define kNav_Height  ((IS_iPhoneX) ? 88: 64)
// 底部tabbar高度
#define kTabbar_Height   ((IS_iPhoneX) ? 83: 49)
// 顶部与底部安全区高度
#define kTopMargin  ((IS_iPhoneX) ? 44: 0)
#define kBottomMargin  ((IS_iPhoneX) ? 34: 0)


#endif /* CustomNavi_h */
