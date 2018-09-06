//
//  VerticalSuperController.m
//  test
//
//  Created by youyu on 2018/4/20.
//  Copyright © 2018年 youyu. All rights reserved.
//

#import "VerticalSuperController.h"

@interface VerticalSuperController ()

@end

@implementation VerticalSuperController

// 以下两个方法可以防止调用不存在的方法而导致崩溃
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        signature = [NSString methodSignatureForSelector:@selector(stringWithFormat:)];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
