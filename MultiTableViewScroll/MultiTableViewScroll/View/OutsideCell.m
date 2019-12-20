//
//  OutsideCell.m
//  Test
//
//  Created by 游宇的Macbook on 2019/12/18.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import "OutsideCell.h"

@implementation OutsideCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}


#pragma mark - Private Func
- (void)setupSubviews {
    [self.contentView addSubview:self.textLb];
}

- (void)setupConstraints {
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
}

- (UILabel *)textLb {
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.textColor = UIColorFromRGB(0x666666);
        _textLb.font = [UIFont systemFontOfSize:17];
        _textLb.text = @"筛选";
        
    }
    return _textLb;
}


@end
