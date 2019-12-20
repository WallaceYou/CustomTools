//
//  InsideTableView.h
//  Test
//
//  Created by 游宇的Macbook on 2019/12/16.
//  Copyright © 2019 YuYou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InsideTableView : UITableView

/** cell点击回调 */
@property (nonatomic, copy) void(^didSelectIndexPath)(NSInteger row);

@end

NS_ASSUME_NONNULL_END
