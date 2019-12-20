//
//  InsideTableView.m
//  Test
//
//  Created by 游宇的Macbook on 2019/12/16.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import "InsideTableView.h"
#import "InsideCell.h"

@interface InsideTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation InsideTableView

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
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[InsideCell class] forCellReuseIdentifier:@"InsideCell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insideTableGoToTop) name:kGoTopNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//小tableView到达顶端
- (void)insideTableGoToTop {
    self.showsVerticalScrollIndicator = YES;
    self.canScroll = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil];
        self.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.showsVerticalScrollIndicator = NO;
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    InsideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InsideCell"];
    cell.textLb.text = [NSString stringWithFormat:@"小table的滴%ld行",indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectIndexPath) {
        self.didSelectIndexPath(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor grayColor];

    //成交时间
    UILabel *label4 = [UILabel new];
    label4.text = [NSString stringWithFormat:@"小table的滴%ld个section",section];
    label4.textColor = [UIColor redColor];
    label4.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((14.5));
        make.centerY.mas_equalTo(0);
    }];

    return headerView;
}


@end
