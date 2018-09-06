//
//  YYZoomLayout.m
//  YYZoomCollectionView
//
//  Created by yuyou on 2018/6/1.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import "YYZoomLayout.h"

@implementation YYZoomLayout

#pragma Overwrite

- (void)prepareLayout {
    
    [super prepareLayout];
    
    //如果需要空出一个位置，则调用下方代码
    if (self.sectionInsetEnable) {
        CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
        self.sectionInset = UIEdgeInsetsMake(self.sectionInset.top,
                                             inset,
                                             self.sectionInset.top,
                                             inset);
    }
    
}

/** 返回值为rect范围内所有元素的布局属性, 即排布方式(frame) */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<UICollectionViewLayoutAttributes *> *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView的centerX
    CGFloat collectionViewConterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat delta = ABS(attributes.center.x - collectionViewConterX);
        //中间的cell最大，放大了1.25倍，其余的cell根据其距离中心点的间距，依次缩小
        CGFloat scale = 1.25f - delta / self.collectionView.frame.size.width;
        NSLog(@"%lf",scale);
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    
    return array;
}

/** bounds改变, 实时刷新layout 默认NO */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/* 每次拖动时，最终一定要使一个cell显示在中间位置 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        /* 循环，寻找离中心点最近的那个cell，并计算出它离中心点的距离 */
        if (ABS(minDelta) > ABS(attributes.center.x - centerX)) {
            minDelta = attributes.center.x - centerX;
        }
    }
    
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}







#pragma mark - Setter

- (void)setCellCountOnhorizontal:(CGFloat)cellCountOnhorizontal {
    _cellCountOnhorizontal = cellCountOnhorizontal;
    
}




@end
