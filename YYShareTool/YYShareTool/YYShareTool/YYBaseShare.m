//
//  YYBaseShare.m
//  MyCoinRisk
//
//  Created by yuyou on 2018/8/7.
//  Copyright © 2018年 hengtiansoft. All rights reserved.
//

#import "YYBaseShare.h"

#define kWindowH [UIScreen mainScreen].bounds.size.height
#define kWindowW [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define StartAnimateDuration    .8
#define CloseAnimateDuration    .25
#define CollectionViewHeight    ({\
CGFloat collectionViewHeight = 0;\
if (self.showType == PlatformShowTypeHorizontal) {\
    collectionViewHeight = self.cellSize.height;\
} else {\
    NSInteger verticalCount = (kWindowW-self.platformCollectionInset*2)/self.cellSize.width;\
    NSInteger lineCount = ceil((CGFloat)self.platformImageNames.count / verticalCount);\
    collectionViewHeight = (self.cellSize.height * lineCount) + (lineCount-1)*CellLineSpacing;\
}\
collectionViewHeight;\
})
#define ShareBgViewHeight (CollectionViewHeight+175)

#define CellColumnSpacing   5    //列间距
#define CellLineSpacing     10   //行间距

//动画多显示的长度
#define SpringInset         20



@interface PlatformCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *platformIconBtn;

@property (nonatomic, strong) UILabel *platformLb;

@end


@implementation PlatformCell

- (UIButton *)platformIconBtn {
    if (!_platformIconBtn) {
        _platformIconBtn = [UIButton new];
        [_platformIconBtn addTarget:self action:@selector(platformIconBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_platformIconBtn];
        [_platformIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(0);
        }];
    }
    return _platformIconBtn;
}


- (UILabel *)platformLb {
    if (!_platformLb) {
        _platformLb = [UILabel new];
        _platformLb.textAlignment = NSTextAlignmentCenter;
        _platformLb.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_platformLb];
        [_platformLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _platformLb;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.platformIconBtn.hidden = NO;
        self.platformLb.hidden = NO;
    }
    return self;
}

- (void)platformIconBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlatformIconBtnClick" object:nil userInfo:@{@"cell":self}];
}

@end




@interface YYBaseShare () <UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate>

//半透明黑色背景视图，点击可以关闭分享视图
@property (nonatomic, strong) UIButton *shareShadowView;

//分享视图
@property (nonatomic, strong) UIView *shareBgView;

//承载平台的collectionView
@property (nonatomic, strong) UICollectionView *shareCollectionView;

@property (nonatomic, copy) void(^closeAnimateComplete)(void);

@end


@implementation YYBaseShare

- (void)dealloc {
    NSLog(@"BaseShare被销毁了");
}

#pragma mark - 公共方法
- (void)popShareViewWithPopAnimateComplete:(void (^)(void))popAnimateComplete closeAnimateComplete:(void (^)(void))closeAnimateComplete {
    
    self.closeAnimateComplete = closeAnimateComplete;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformIconBtnClick:) name:@"PlatformIconBtnClick" object:nil];
    
    //半透明黑色背景视图，点击可以关闭分享视图
    UIButton *shareShadowView = [UIButton new];
    shareShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [shareShadowView addTarget:self action:@selector(shareShadowViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.shareShadowView = shareShadowView;
    
    //window
    UIView *kWindow = [UIApplication sharedApplication].keyWindow;
    [kWindow addSubview:shareShadowView];
    shareShadowView.frame = CGRectMake(0, 0, kWindowW, kWindowH);
    
    //分享视图
    UIView *shareBgView = [UIView new];
    shareBgView.backgroundColor = UIColorFromRGBA(242, 242, 242, 0.98);
    [shareShadowView addSubview:shareBgView];
    shareBgView.frame = CGRectMake(0, kWindowH, kWindowW, ShareBgViewHeight+SpringInset);
    self.shareBgView = shareBgView;
    
    //分享视图内的子视图
    //分享Label
    UILabel *shareLb = [UILabel new];
    shareLb.text = @"分享";
    [shareBgView addSubview:shareLb];
    [shareLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    
    //承载各个平台的collectionView
    [shareBgView addSubview:self.shareCollectionView];
    [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(shareLb.mas_bottom).mas_equalTo(27);
        make.height.mas_equalTo(CollectionViewHeight);
    }];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setBackgroundImage:[self createImageWithColor:UIColorFromRGBA(251, 251, 251, 1)] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[self createImageWithColor:UIColorFromRGBA(231, 231, 231, 1)] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(shareShadowViewClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-34-SpringInset);
        make.height.mas_equalTo(46);
    }];
    
    
    //开始动画
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        shareShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        shareBgView.frame = CGRectMake(0, kWindowH-ShareBgViewHeight-10, kWindowW, ShareBgViewHeight+SpringInset);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            shareBgView.frame = CGRectMake(0, kWindowH-ShareBgViewHeight+5, kWindowW, ShareBgViewHeight+SpringInset);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                shareBgView.frame = CGRectMake(0, kWindowH-ShareBgViewHeight, kWindowW, ShareBgViewHeight+SpringInset);
                
            } completion:^(BOOL finished) {
                if (popAnimateComplete) {
                    popAnimateComplete();
                }
            }];
        }];
    }];
    
}



#pragma mark - 私有方法
- (UIImage *)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//关闭动画
- (void)closeShareViewWithAnimateComplete:(void(^)(void))animateComplete {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlatformIconBtnClick" object:nil];
    
    [UIView animateWithDuration:CloseAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shareShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.shareBgView.frame = CGRectMake(0, kWindowH, kWindowW, ShareBgViewHeight+SpringInset);
    } completion:^(BOOL finished) {
        
        if (self.shareShadowView.superview) {
            [self.shareShadowView removeFromSuperview];
            self.shareShadowView = nil;
        }
        
        if (animateComplete) {
            animateComplete();
        }
    }];
}


#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.platformImageNames.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformCell" forIndexPath:indexPath];
//    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    NSString *imageName = [self.platformImageNames objectAtIndex:indexPath.row];
    NSString *platformName = @"";
    if (self.platforms.count > indexPath.row) {
        platformName = [self.platforms objectAtIndex:indexPath.row];
    }
    
    [cell.platformIconBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    cell.platformLb.text = platformName;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickPlatform) {
        
        //先关闭再回调
        [self closeShareViewWithAnimateComplete:^{
            self.clickPlatform(indexPath.row, self.platforms[indexPath.row]);
            if (self.closeAnimateComplete) {
                self.closeAnimateComplete();
            }
        }];
    }
}


#pragma mark - 按钮点击
- (void)shareShadowViewClick {
    [self closeShareViewWithAnimateComplete:^{
        if (self.closeAnimateComplete) {
            self.closeAnimateComplete();
        }
    }];
}

- (void)platformIconBtnClick:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UICollectionViewCell *cell = userInfo[@"cell"];
    NSIndexPath *indexPath = [self.shareCollectionView indexPathForCell:cell];
    
    [self collectionView:self.shareCollectionView didSelectItemAtIndexPath:indexPath];
    
}


#pragma mark - 懒加载
- (UICollectionView *)shareCollectionView {
    if (!_shareCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, self.platformCollectionInset, 0, self.platformCollectionInset);
        
        if (self.showType == PlatformShowTypeHorizontal) {
            //设置行间距，因为横向显示的话，就只有一行，所以这个值设多少都没关系
            layout.minimumInteritemSpacing = CellLineSpacing;
            
            //计算列间距
            CGFloat columnSpacing = (kWindowW-(self.platformCollectionInset * 2)-(self.cellSize.width * self.platformImageNames.count))/(self.platformImageNames.count-1);
            
            //最小列间距如果为负数说明已经超过一个width所显示的内容，则设置为5
            if (columnSpacing < 0) {
                columnSpacing = CellColumnSpacing;
            }
            layout.minimumLineSpacing = columnSpacing;
        } else {
            //设置行间距默认为10（注意，横向和纵向，minimumInteritemSpacing和minimumLineSpacing是反的）
            layout.minimumLineSpacing = CellLineSpacing;
            
            //一行最多能显示几个，即列数
            NSInteger verticalCount = (kWindowW-self.platformCollectionInset*2)/self.cellSize.width;
            if (verticalCount > self.platformImageNames.count) {
                verticalCount = self.platformImageNames.count;
            }
            
            //计算列间距
            CGFloat columnSpacing = ((kWindowW-self.platformCollectionInset*2)-(self.cellSize.width*verticalCount))/(verticalCount-1);
            
            layout.minimumInteritemSpacing = columnSpacing;
            
        }
        
        
        layout.itemSize = self.cellSize;
        layout.scrollDirection = self.showType == PlatformShowTypeHorizontal?UICollectionViewScrollDirectionHorizontal:UICollectionViewScrollDirectionVertical;
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _shareCollectionView.dataSource = self;
        _shareCollectionView.backgroundColor = [UIColor clearColor];
        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        _shareCollectionView.showsVerticalScrollIndicator = NO;
        _shareCollectionView.delegate = self;
        [_shareCollectionView registerClass:[PlatformCell class] forCellWithReuseIdentifier:@"PlatformCell"];
    }
    return _shareCollectionView;
}


@end
