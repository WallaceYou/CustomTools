//
//  YYShareTool.m
//  MyCoinRisk
//
//  Created by yuyou on 2018/8/14.
//  Copyright © 2018年 hengtiansoft. All rights reserved.
//

#import "YYShareTool.h"
#import "YYBaseShare.h"
#import <UMShare/UMShare.h>


@interface YYShareTool ()

@property (nonatomic, strong) YYBaseShare *baseShare;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) id pic;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *shareUrl;

@end


@implementation YYShareTool


#pragma mark - 单例对象
+ (instancetype)shareInstance {
    static YYShareTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[YYShareTool alloc] init];
    });
    return tool;
}


#pragma mark - 供外界调用的类方法
+ (void)shareToTripartitePlatformWithTitle:(NSString *)title pic:(id)pic content:(NSString *)content shareUrl:(NSString *)shareUrl {
    YYShareTool *tool = [self shareInstance];
    tool.title = title;
    tool.pic = pic;
    tool.content = content;
    tool.shareUrl = shareUrl;
    
    
    //当baseShare关闭后，记得销毁，因为shareTool在静态区，不会被释放，整个App共用一个，而他内部的baseShare在堆区，要记得销毁，不然会一直被引用
    [tool.baseShare popShareViewWithPopAnimateComplete:nil closeAnimateComplete:^{
        tool.baseShare = nil;
    }];
}




- (void)shareToTripartiteWithPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title pic:(id)pic content:(NSString *)content shareUrl:(NSString *)shareUrl successComplete:(void (^)(id))successComplete failureComplete:(void (^)(NSError *))failureComplete {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:pic];
    
    //设置网页地址
    shareObject.webpageUrl =shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            
            if (failureComplete) {
                failureComplete(error);
            }
            
        } else {
            
            if (successComplete) {
                successComplete(data);
            }
        }
    }];
}

#pragma mark - 点击三方平台的回调事件
- (void)shareToPlatform:(NSInteger)index platform:(NSString *)platform {
    
    void(^successComplete)(id) = ^(id data) {
        NSLog(@"response data is %@",data);
        //这里写分享成功的回调，比如显示分享成功
//        [MBProgressHUD showSuccess:@"分享成功"];
    };
    
    void(^failureComplete)(NSError *) = ^(NSError *error) {
        NSLog(@"************Share fail with error %@*********",error);
        //这里写分享失败的回调，比如显示分享失败
//        [MBProgressHUD showError:@"分享失败"];
    };
    
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    
    switch (index) {
        case 0:
            type = UMSocialPlatformType_Twitter;
            break;
        case 1:
            type = UMSocialPlatformType_Linkedin;
            break;
        case 2:
            type = UMSocialPlatformType_Facebook;
            break;
        case 3:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 4:
            type = UMSocialPlatformType_Sina;
            break;
            
        default:
            break;
    }
    
    [self shareToTripartiteWithPlatformType:type title:self.title pic:self.pic content:self.content shareUrl:self.shareUrl successComplete:successComplete failureComplete:failureComplete];
}



#pragma mark - 懒加载
- (YYBaseShare *)baseShare {
    if (!_baseShare) {
        _baseShare = [YYBaseShare new];
        _baseShare.platformCollectionInset = 20;//左右间距
        _baseShare.cellSize = CGSizeMake(60, 65);//cell大小
        _baseShare.platformImageNames = @[@"share_twitter",@"share_linkedin",@"share_facebook",@"share_wechat",@"share_weibo",@"share_twitter",@"share_linkedin",@"share_facebook",@"share_wechat",@"share_weibo",@"share_weibo"];//三方平台icon图片名
        _baseShare.platforms = @[@"Twitter",@"Linkedin",@"Facebook",@"Wechat",@"Weibo",@"Twitter",@"Linkedin",@"Facebook",@"Wechat",@"Weibo",@"Weibo"];//三方平台名称
        _baseShare.showType = PlatformShowTypeVertical;//三方平台的展示方向，横向还是纵向
        __weak typeof(self) weakSelf = self;
        _baseShare.clickPlatform = ^(NSInteger index, NSString *platform) {//点击回调事件
            [weakSelf shareToPlatform:index platform:platform];
        };
    }
    return _baseShare;
}


@end
