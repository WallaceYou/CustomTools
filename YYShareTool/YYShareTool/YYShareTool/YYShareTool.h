//
//  YYShareTool.h
//  MyCoinRisk
//
//  Created by yuyou on 2018/8/14.
//  Copyright © 2018年 yuyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYShareTool : NSObject

/** 弹出分享面板，参数分别为 */
+ (void)popShareViewWithPopAnimateComplete:(void(^)(void))popAnimateComplete closeAnimateComplete:(void(^)(void))closeAnimateComplete clickPlatform:(void(^)(NSInteger index, NSString *platform))clickPlatform;


/**
 *  分享到第三方平台
 *
 *  @param index                分享的平台
 *  @param title                分享的title
 *  @param pic                  分享显示的图片（UIImage或者NSData类型，或者image_url）
 *  @param content              分享的内容
 *  @param shareUrl             分享的URL
 *
 */
+ (void)shareToTripartitePlatformWithIndex:(NSInteger)index title:(NSString *)title pic:(id)pic content:(NSString *)content shareUrl:(NSString *)shareUrl;

@end
