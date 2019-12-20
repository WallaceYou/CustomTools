//
//  OutsideTableCell.m
//  Test
//
//  Created by 游宇的Macbook on 2019/12/18.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import "OutsideTableCell.h"
#import "InsideTableView.h"

@interface OutsideTableCell ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) InsideTableView *insideTableView;

@end

@implementation OutsideTableCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}


#pragma mark - Private Func
- (void)setupSubviews {
    
    [self.scrollView addSubview:self.insideTableView];
    [self.insideTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-40));//必须设置尺寸，这样才能将scrollView撑起来
    }];
    
}



- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _scrollView;
}


- (InsideTableView *)insideTableView {
    if (!_insideTableView) {
        _insideTableView = [[InsideTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _insideTableView;
}

@end
