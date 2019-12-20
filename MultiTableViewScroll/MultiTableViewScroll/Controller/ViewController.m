//
//  ViewController.m
//  MultiTableViewScroll
//
//  Created by 游宇的Macbook on 2019/12/20.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import "ViewController.h"
#import "OutsideTableView.h"

@interface ViewController ()

@property (nonatomic, strong) OutsideTableView *outSideTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    // Do any additional setup after loading the view.
}

- (void)setupSubviews {
    
    self.outSideTableView.hidden = NO;
}


- (OutsideTableView *)outSideTableView {
    if (!_outSideTableView) {
        _outSideTableView = [[OutsideTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _outSideTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_outSideTableView];
        [_outSideTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _outSideTableView;
}



@end
