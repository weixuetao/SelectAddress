//
//  HttpRequest.m
//  StarwayLive
//
//  Created by xinglu on 16/1/11.
//  Copyright © 2016年 xinglu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest ()<UIAlertViewDelegate>

@end


@implementation HttpRequest

+ (void)commonNetRequestUrl:(NSString *)requestUrl Paramete:(id)parDict isShowHud:(BOOL)isShow respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [self paramToJsonDataWithDict:parDict];
        
        if (requestUrl.length == 0)
        {
        
            return;
        }
        
        
        NSURL *URL = [NSURL URLWithString:requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        
        if (data)
        {
            //设置请求
            [request setValue:[NSString stringWithFormat:@"%ld",(long)[data length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            [request setHTTPBody:data];
        }
        
        /**
         *  超时判断
         */
        [request setTimeoutInterval:10];
        
        
        /**
         *  显示加载状态
         */
        if (isShow)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
               
            });
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        /**
         *  网络请求
         */
        NSURLSession * sharedSession = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            
            /**
             *  隐藏加载状态
             */
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (isShow)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                   
                });
            }
            
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    // NSLocalizedString(@"RequestF",nil)
                    faild(nil);
                });
                
            }
            else
            {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                
                NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                int i = [[dictionary objectForKey:@"errorCode"] intValue];
                if (i == 0&&dictionary !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success([dictionary objectForKey:@"data"]);
                    });
                }else if (dictionary == nil){
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                    });
                    faild(nil);
                } else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dictionary objectForKey:@"errorCode"] intValue] == 90002) {
                            
                        }else{
                            NSString * erroInfo = [NSString stringWithFormat:@"KKYERROR:%@",[dictionary objectForKey:@"errorCode"]];
                        
                            
                        }
                        faild(dictionary);
                    });
                    
                }
            }
        }];
        
        [task resume];
    });
}

+ (NSData *)paramToJsonDataWithDict:(NSDictionary *)dict{
    
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            //DebugLog(@"[%@] Post Json Error: %@", [self class], dict);
        }
        else
        {
           // DebugLog(@"[%@] Post Json : %@", [self class], dict);
        }
        return data;
    }else
    {
        //DebugLog(@"[%@] Post Json is not valid: %@", [self class], dict);
    }
    return nil;
}


- (void)dealloc{
   // DebugLog(@"=========[%@] release成功>>>>>>>>>", NSStringFromClass([self class]));
}


@end
