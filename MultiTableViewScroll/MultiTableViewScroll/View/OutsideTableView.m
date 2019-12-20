//
//  OutsideTableView.m
//  Test
//
//  Created by 游宇的Macbook on 2019/12/16.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import "OutsideTableView.h"
#import "OutsideCell.h"
#import "OutsideTableCell.h"

@interface OutsideTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) CGPoint fixOffset;



@end

@implementation OutsideTableView

#pragma mark - Allow Multiple Gestures To Exsit
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 200;
        if (@available(iOS 11.0, *)) {
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.canScroll = YES;
        self.showsVerticalScrollIndicator  = YES;
        [self registerClass:[OutsideCell class] forCellReuseIdentifier:@"OutsideCell"];
        [self registerClass:[OutsideTableCell class] forCellReuseIdentifier:@"OutsideTableCell"];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insideTableLeaveToTop) name:kLeaveTopNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//小tableView离开顶端
- (void)insideTableLeaveToTop {
    self.showsVerticalScrollIndicator = YES;
    self.canScroll = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        [scrollView setContentOffset:self.fixOffset];
        return;
    }
    CGFloat tabOffsetY = [self rectForSection:1].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY ----- %f",offsetY);
    NSLog(@"tabOffsetY ----- %f",tabOffsetY);
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"小tableView滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
            self.fixOffset = scrollView.contentOffset;
            self.showsVerticalScrollIndicator = NO;
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        OutsideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutsideCell"];
        cell.textLb.text = [NSString stringWithFormat:@"大table的第%ld行",indexPath.row];
        return cell;
    } else {
        OutsideTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutsideTableCell"];
        return cell;
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectIndexPath) {
        self.didSelectIndexPath(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return SCREEN_HEIGHT-40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor greenColor];

    //header上的label
    UILabel *headerLb = [UILabel new];
    headerLb.text = [NSString stringWithFormat:@"大table的第%ld个section",section];
    headerLb.textColor = [UIColor redColor];
    headerLb.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:headerLb];
    [headerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((14.5));
        make.centerY.mas_equalTo(0);
    }];

    return headerView;
}




@end
