//
//  HttpRequest.h
//  StarwayLive
//
//  Created by xinglu on 16/1/11.
//  Copyright © 2016年 xinglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^RespondBlock)(id json);

typedef void(^FaildBlock)(id errorInfo);

@interface HttpRequest : NSObject



+ (void)commonNetRequestUrl:(NSString *)requestUrl Paramete:(id)parDict isShowHud:(BOOL)isShow respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;

@end
