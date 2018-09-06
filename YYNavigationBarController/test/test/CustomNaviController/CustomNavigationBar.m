//
//  CustomNavigationBar.m
//  KuGe
//
//  Created by yuyou on 2018/6/8.
//  Copyright © 2018年 YuYou. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "CustomNavi.h"


@interface CustomNavigationBar ()

/** 导航栏底部线 */
@property (nonatomic, strong) UIView *naviBottomLine;

/** 导航栏左边的按钮视图 */
@property (nonatomic, strong) UIView *leftBarButtonItem;

/** 导航栏右边的按钮视图 */
@property (nonatomic, strong) UIView *rightBarButtonItem;

@end

@implementation CustomNavigationBar

#pragma mark - 初始化
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSubviews];
}

- (void)dealloc {
//    NSLog(@"");
}

- (instancetype)init {
    if (self = [super init]) {
        [self setSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.offset(kStatusBarHeight/2);
    }];
    
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.top.mas_equalTo(0);
        
        if (self.titleView.bounds.size.width > 0) {//不会造成引用循环
            make.width.mas_equalTo(self.titleView.bounds.size.width);
        } else {
            make.width.mas_equalTo((kIfHorizontal?265:80)*kWidthScale);
        }
    }];
    
    [self.leftBarButtonItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kIfHorizontal?15:4)*kWidthScale);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kIfHorizontal?250:220)*kWidthScale);
    }];
    
    [self.rightBarButtonItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(kIfHorizontal?15:4)*kWidthScale);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.leftBarButtonItem.mas_width);
    }];
    
    //重新排布内部button
    self.leftBarButtonItems = self.leftBarButtonItems;
    self.rightBarButtonItems = self.rightBarButtonItems;
    
}


#pragma mark - 重写set方法

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setNaviBottomLineHidden:(BOOL)naviBottomLineHidden {
    _naviBottomLineHidden = naviBottomLineHidden;
    self.naviBottomLine.hidden = naviBottomLineHidden;
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems {
    
    if (leftBarButtonItems.count < 1) {
        return;
    }
    
    if (_leftBarButtonItems != leftBarButtonItems) {
        //设置左边的按钮数组，就将左边的按钮父视图放在最上面
        [self bringSubviewToFront:_leftBarButtonItem];
    }
    
    for (UIView *view in _leftBarButtonItems) {//如果之前是有按钮的，则全部移除
        [view removeFromSuperview];
    }
    
    _leftBarButtonItems = leftBarButtonItems;
    
    // 遍历按钮数组，将里面的所有按钮放在左上角leftBarButtonItem视图上
    UIView *lastView = nil;
    for (int i = 0;i<leftBarButtonItems.count;i++) {
        UIView *b = leftBarButtonItems[i];
        
        BOOL ifView = [b isMemberOfClass:[UIView class]];
        [self.leftBarButtonItem addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (ifView) {
                make.bottom.mas_equalTo(0);
            } else {
                make.centerY.offset(kStatusBarHeight/2);
            }
            
            if (lastView == nil) {
                make.left.mas_equalTo(10*kWidthScale);
            } else {
                make.left.mas_equalTo(lastView.mas_right).mas_equalTo(20*kWidthScale);
            }
            
            if (!ifView) {//如果不是View则设置size，是view 则在外面自定义size
                CGSize size = [self barButtonSizeWith:b];
                make.size.mas_equalTo(size);
            } else {//如果是View，则根据bounds设置大小
                CGFloat width = b.bounds.size.width;
                if (width > 0) {
                    make.width.mas_equalTo(width);
                }
                make.height.mas_equalTo(self.mas_height).offset(-kStatusBarHeight);
            }
            
        }];
        lastView = leftBarButtonItems[i];
    }
}


- (void)setTitleView:(UIView *)titleView {
    
    [_titleView removeFromSuperview];
    _titleView = nil;
    _textLabel = nil;//由于titleView都替换了，所以_textLabel也就没有存在的必要了
    
    _titleView = titleView;
    
    [self addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.top.mas_equalTo(0);
        
        if (self.titleView.bounds.size.width > 0) {//不会造成引用循环
            make.width.mas_equalTo(self.titleView.bounds.size.width);
        }
        
    }];
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems {
    
    if (rightBarButtonItems.count < 1) {
        return;
    }
    
    if (_rightBarButtonItems != rightBarButtonItems) {
        //设置右边的按钮数组，就将右边的按钮父视图放在最上面
        [self bringSubviewToFront:_rightBarButtonItem];
    }
    
    for (UIView *view in _rightBarButtonItems) {//如果之前是有按钮的，则全部移除
        [view removeFromSuperview];
    }
    _rightBarButtonItems = rightBarButtonItems;
    
    // 遍历按钮数组，将里面的所有按钮放在右上角rightBarButtonItem视图上
    UIView *lastView = nil;
    for (int i = 0;i<rightBarButtonItems.count;i++) {
        UIView *b = rightBarButtonItems[i];
        
        BOOL ifView = [b isMemberOfClass:[UIView class]];
        [self.rightBarButtonItem addSubview:b];
        
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (ifView) {
                make.bottom.mas_equalTo(0);
            } else {
                make.centerY.offset(kStatusBarHeight/2);
            }
            
            if (lastView == nil) {
                make.right.mas_equalTo(-10*kWidthScale);
            } else {
                make.right.mas_equalTo(lastView.mas_left).mas_equalTo(-20*kWidthScale);
            }
            
            if (!ifView) {//如果不是View则设置size，是view 则在外面自定义size
                CGSize size = [self barButtonSizeWith:b];
                make.size.mas_equalTo(size);
            } else {//如果是View，则根据bounds大小设置width。而height固定为导航栏的高度（不带状态栏）
                CGFloat width = b.bounds.size.width;
                if (width > 0) {
                    make.width.mas_equalTo(width);
                }
                make.height.mas_equalTo(self.mas_height).offset(-kStatusBarHeight);
            }
        }];
        lastView = rightBarButtonItems[i];
    }
}


#pragma mark - 私有方法

- (void)setSubviews {
    
    // 左右两侧的按钮数组View
    _leftBarButtonItem = [UIView new];
    _rightBarButtonItem = [UIView new];
    
    // 导航栏底部线视图
    _naviBottomLine = [UIView new];
    _naviBottomLine.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
    
//                _leftBarButtonItem.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
//                _rightBarButtonItem.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    // 中间titleView
    _titleView = [UIView new];
//                _titleView.backgroundColor = [UIColor greenColor];
    self.textLabel = [UILabel new];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.textLabel];
    
    // 中间titleView约束
    [self addSubview:self.titleView];
    
    // 左侧按钮数组父视图约束
    [self addSubview:_leftBarButtonItem];
    
    // 右侧按钮数组父视图约束
    [self addSubview:_rightBarButtonItem];
    
    // 导航栏底部线约束
    [self addSubview:_naviBottomLine];
    [_naviBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

/* 计算button的size */
- (CGSize)barButtonSizeWith:(UIView *)btn {
    UIImage *btnImage = [btn valueForKey:@"currentBackgroundImage"];
    if (btnImage == nil) {
        btnImage = [btn valueForKey:@"currentImage"];
    }
    
    CGSize size = CGSizeMake(40*kScale, 40*kScale);
    if (btnImage != nil) {//执行到这里，说明此button是赋值了Image的btton（或者backgroundImage）
        
        if (btnImage.size.width > 1) {//宽度大于1说明是设置非纯颜色的image，小于等于1说明是纯颜色的Image，则不设置size，默认40
            size = CGSizeMake(btnImage.size.width*kScale, btnImage.size.height*kScale);
        }
        
    } else {
        NSString *btnTitle = [btn valueForKeyPath:@"titleLabel.text"];
        UIFont *btnFont = [btn valueForKeyPath:@"titleLabel.font"];
        
        if (!([btnTitle isEqualToString:@""] || btnTitle == nil)) {//如果走了这个if判断，说明是个有title的button，没走这个if说明是既没设置Image又没设置title，则默认size为40*kScale
            CGFloat btnWidth = [self widthWithFont:btnFont title:btnTitle constrainedToHeight:100];
            CGFloat btnHeight = [self heightWithFont:btnFont title:btnTitle constrainedToWidth:100];
            size = CGSizeMake(btnWidth, btnHeight);
        }
    }
    
    return size;
    
}

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font title:(NSString *)title constrainedToWidth:(CGFloat)width {
    
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:(NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingTruncatesLastVisibleLine)
                                attributes:attributes
                                   context:nil].size;
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font title:(NSString *)title constrainedToHeight:(CGFloat)height {
    
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                   options:(NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingTruncatesLastVisibleLine)
                                attributes:attributes
                                   context:nil].size;
    
    return ceil(textSize.width);
}


@end
