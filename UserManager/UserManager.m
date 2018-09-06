//
//  UserManager.m
//  SupremeGolfPro
//
//  Created by yuyou on 2017/3/2.
//  Copyright © 2017年 yuyou. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"

#define G_USER_TOKEN    @"g_user_token"
#define G_USER_INFO     @"g_user_info"
#define G_IS_LOGIN      @"g_is_login"
#define G_YES           @(YES)


@interface UserManager ()

@property(nonatomic, strong) NSString *userToken;
@property(nonatomic, strong) UserModel *userInfo;

@end

@implementation UserManager

#pragma mark - 单例对象
+ (instancetype)SharedUserDefaultObj {
    static UserManager *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UserManager alloc] init];
    });
    return model;
}

/* 获取用户token */
+ (NSString *)getUserToken {
    UserManager *obj = [self SharedUserDefaultObj];
    if (obj.userToken) {
        return obj.userToken;
        
    }else {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSString *userToken = [config objectForKey:G_USER_TOKEN]; //G_USER_TOKEN = @"g_user_token"
        if (userToken) {
            obj.userToken = userToken;
            return userToken;
        }
        return nil;
    }
}

/* 获取用户信息(不包括token) */
+ (UserModel *)getUserInfo {
    UserManager *obj = [self SharedUserDefaultObj];
    if (obj.userInfo) {
        return obj.userInfo;
    }else {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfoDic = [config objectForKey:G_USER_INFO]; //G_USER_INFO = @"g_user_info"
        if (userInfoDic) {
            UserModel *model = [UserModel mj_objectWithKeyValues:userInfoDic];
            obj.userInfo = model;
            return model;
        }
        return nil;
    }
}



/* 是否登录 */
+ (BOOL)isLogin {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    id isLogin = [config objectForKey:G_IS_LOGIN];
    return isLogin;
}

/* 更新用户部分信息, dic为提交网络请求的参数字典 */
+ (void)updateUserInfoWithDic:(NSDictionary *)dic {
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldDic = [config objectForKey:G_USER_INFO]; //G_USER_INFO = @"g_user_info"
    if (!oldDic) { //本地无用户信息,  则不需要修改
        return;
    }
    
    if (!dic || dic.allKeys.count == 0) {
        return;
    }
    
    NSMutableDictionary *newsDic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
    for (NSString *keyString in dic) { //遍历请求字典,  根据每个key更新本地对应key的value
        if (newsDic[keyString]) {
            [newsDic setObject:dic[keyString] forKey:keyString];
        }
    }
    [config setObject:[newsDic copy] forKey:G_USER_INFO]; //G_USER_INFO = @"g_user_info"
    
    if ([config synchronize]) {
        UserManager *obj = [self SharedUserDefaultObj];
        obj.userInfo = [UserModel mj_objectWithKeyValues:newsDic];
    }
}

/* 清除用户信息 */
+ (void)removeUserInfo {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config removeObjectForKey:G_IS_LOGIN]; // @"g_is_login"
    [config removeObjectForKey:G_USER_TOKEN]; //@"g_user_token"
    [config removeObjectForKey:G_USER_INFO]; //@"g_user_info"
    
}

#pragma mark - 保存用户登录后的一些必要信息
+ (void)setUserWithDicData:(NSDictionary *)dicData{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:G_YES forKey:G_IS_LOGIN]; //@"g_yes" @"g_is_login"
    
//    NSDictionary *itemDic = [dicData objectForKey:@"data"];
//    if (!itemDic || [itemDic isKindOfClass:[NSNull class]]) {
//        return;
//    }
    NSDictionary *itemDic = dicData;
    
    NSMutableDictionary *itemMutDic = [NSMutableDictionary dictionaryWithDictionary:itemDic];
    for (NSString *key in itemDic) {
        id value = itemMutDic[key];
        if (!value || [value isKindOfClass:[NSNull class]]) {
            value = @"";
            [itemMutDic setObject:value forKey:key];
        }
    }
    UserManager *obj = [self SharedUserDefaultObj];
    obj.userInfo = [UserModel mj_objectWithKeyValues:itemMutDic];
    
    NSString *userToken = [itemMutDic objectForKey:@"token"];
    if (userToken) {
        obj.userToken = userToken;
        [config setObject:userToken forKey:G_USER_TOKEN];  //@"g_user_token"
    }
    
    [config setObject:[itemMutDic copy] forKey:G_USER_INFO]; //@"g_user_info"
    [config synchronize];
    
}


@end
