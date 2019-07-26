//
//  UIButton+Custom.m
//  Mu
//
//  Created by 游宇的Macbook on 2018/3/28.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import "UIButton+Custom.h"
#import "Masonry.h"

/* 获得image在当前屏幕应该显示的尺寸大小 */
#define CGSizeFromImage(image) CGSizeMake(image.size.width, image.size.height)

@implementation UIButton (Custom)

+ (UIButton *)buttonWithButtonName:(NSString *)buttonName buttonBgName:(NSString *)buttonBgName offset:(CGPoint)offset {
    
    //创建背景
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:buttonBgName];
    UIImage *btnImageHighlighted = [UIImage imageNamed:[buttonBgName stringByAppendingString:@"_highlighted"]];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImage:btnImageHighlighted forState:UIControlStateHighlighted];
    
    //创建内部icon
    UIImage *iconImage = [UIImage imageNamed:buttonName];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    
    
    [btn addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(offset.y);
        make.centerX.offset(offset.x);
        make.size.mas_equalTo(CGSizeFromImage(iconImage));
    }];
    
    return btn;
    
}


+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont buttonBgName:(NSString *)buttonBgName {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = textFont;
    [btn setImage:[UIImage imageNamed:buttonBgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",buttonBgName]] forState:UIControlStateHighlighted];
    return btn;
}



+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont buttonBgColor:(UIColor *)buttonBgColor {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (textFont) {
        btn.titleLabel.font = textFont;
    }
    [btn setBackgroundImage:[self createImageWithColor:buttonBgColor] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (textFont) {
        btn.titleLabel.font = textFont;
    }
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [borderColor CGColor];
    return btn;
}



- (void)setButtonSpaceWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color spacing:(CGFloat)spacing {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributedic = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(spacing)
                                   };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:attributedic];
    [self setAttributedTitle:attributeStr forState:UIControlStateNormal];
}


+ (UIImage *)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




@end
