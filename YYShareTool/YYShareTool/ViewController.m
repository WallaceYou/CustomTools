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
    
    [YYShareTool popShareViewWithPopAnimateComplete:nil closeAnimateComplete:nil clickPlatform:^(NSInteger index, NSString *platform) {
        
        //这里根据点击的index，得知平台，然后得到分享的url，再调用YYShareTool的分享方法，将分享的url等传入
        [YYShareTool shareToTripartitePlatformWithIndex:index title:@"title" pic:@"这里可以传UIImage或者NSData类型，或者image_url" content:@"content" shareUrl:@"分享的url"];
        
    }];
}

@end
