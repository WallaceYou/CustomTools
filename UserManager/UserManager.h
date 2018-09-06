//
//  UserManager.h
//  SupremeGolfPro
//
//  Created by yuyou on 2017/3/2.
//  Copyright © 2017年 yuyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

/** 用户基本信息操作类 */
@interface UserManager : NSObject


/** 获取用户token */
+ (NSString *)getUserToken;

/** 是否登录 */
+ (BOOL)isLogin;

/** 获取用户信息(不包括token) */
+ (UserModel *)getUserInfo;


/** 更新用户部分信息, dic为提交网络请求的参数字典 */
+ (void)updateUserInfoWithDic:(NSDictionary *)dic;

/** 保存用户登录后的一些必要信息 */
+ (void)setUserWithDicData:(NSDictionary *)dicData;

/** 清除用户信息 */
+ (void)removeUserInfo;




@end
