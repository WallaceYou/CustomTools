//
//  ViewController.m
//  YYZoomCollectionView
//
//  Created by yuyou on 2018/6/1.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import "ViewController.h"
#import "YYZoomLayout.h"
#import "Masonry.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.hidden = NO;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        YYZoomLayout *layout = [YYZoomLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInsetEnable = YES;
        layout.minimumLineSpacing = 15;
        //一页显示3个
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/3,130);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        
        
    }
    return _collectionView;
}


@end
