//
//  UIButton+Custom.h
//  Mu
//
//  Created by 游宇的Macbook on 2018/3/28.
//  Copyright © 2018年 com.morpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

/**
 通过按钮icon图片名字、按钮背景图片名字得到一个带背景的button（规范：其中icon相对于背景在正中间，背景高亮图片名字必须是背景图片名字 + _highlighted）
 
 @param buttonName 按钮icon图片名字
 @param buttonBgName 按钮背景图片名字
 @param offset 按钮内部icon相对于背景的偏移
 @return 按钮
 */
+ (UIButton *)buttonWithButtonName:(NSString *)buttonName buttonBgName:(NSString *)buttonBgName offset:(CGPoint)offset;




/**
 通过按钮title、按钮背景图片名字得到一个带背景的button（规范：背景高亮图片名字必须是背景图片名字 + _highlighted）
 
 @param title           按钮显示的title文字
 @param titleColor       按钮显示文字颜色
 @param textFont        按钮显示文字字体
 @param buttonBgName    按钮背景图片名字
 @return 按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont buttonBgName:(NSString *)buttonBgName;




/**
 通过按钮title、按钮背景颜色得到一个带背景颜色的button（规范：背景高亮图片名字必须是背景图片名字 + _highlighted）
 
 @param title           按钮显示的title文字
 @param titleColor       按钮显示文字颜色
 @param textFont        按钮显示文字字体
 @param buttonBgColor   按钮背景颜色
 @return 按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont buttonBgColor:(UIColor *)buttonBgColor;



/** 创建一个带边框，圆角的button */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;



/* 设置按钮的attributeString，同时设置字间距，颜色，字体 */
- (void)setButtonSpaceWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color spacing:(CGFloat)spacing;


@end
