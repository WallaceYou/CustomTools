//
//  YYZoomLayout.h
//  YYZoomCollectionView
//
//  Created by yuyou on 2018/6/1.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYZoomLayout : UICollectionViewFlowLayout

/** 横向有几个cell */
@property (nonatomic, assign) CGFloat cellCountOnhorizontal;

/** 表示是否有左右间距。如果为NO，表示当滑到最后时，最后的cell无法被放大，反之，任何一个cell都可以被放大 */
@property (nonatomic, assign) BOOL sectionInsetEnable;

@end
