//
//  YYBaseShare.h
//  MyCoinRisk
//
//  Created by yuyou on 2018/8/7.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PlatformShowType) {
    PlatformShowTypeHorizontal,
    PlatformShowTypeVertical,
};


@interface YYBaseShare : NSObject 


/** 各个平台的图片名字 */
@property (nonatomic, strong) NSArray *platformImageNames;

/** 各个平台名字 */
@property (nonatomic, strong) NSArray *platforms;

/** 平台icon加平台名字是一个collectionViewCell，cellSize代表这个cell的size */
@property (nonatomic, assign) CGSize cellSize;

/** 平台collectionView的左右边距距离 */
@property (nonatomic, assign) CGFloat platformCollectionInset;

/** 平台显示方式，横向还是纵向 */
@property (nonatomic, assign) PlatformShowType showType;

/** 点击某个分享平台后执行的回调 */
@property (nonatomic, copy) void(^clickPlatform)(NSInteger index, NSString *platform);

/**
 *  以动画形式弹出一个分享视图
 *
 *  @param popAnimateComplete          弹出动画完成后执行的回调
 *  @param closeAnimateComplete         关闭动画完成后的回调
 */
- (void)popShareViewWithPopAnimateComplete:(void(^)(void))popAnimateComplete closeAnimateComplete:(void(^)(void))closeAnimateComplete;


@end
