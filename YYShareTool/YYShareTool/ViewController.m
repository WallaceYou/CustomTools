//
//  ViewController.m
//  YYShareTool
//
//  Created by yuyou on 2018/9/6.
//  Copyright © 2018年 hengtiansoft. All rights reserved.
//

#import "ViewController.h"
#import "YYShareTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)share:(id)sender {
    [YYShareTool shareToTripartitePlatformWithTitle:@"title" pic:@"这里可以传UIImage或者NSData类型，或者image_url" content:@"content" shareUrl:@"分享的url"];
}

@end
