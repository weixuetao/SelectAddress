//
//  HttpRequest.m
//  StarwayLive
//
//  Created by xinglu on 16/1/11.
//  Copyright © 2016年 xinglu. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNRequestManager.h"
#import "MBProgressHUD.h"
@interface HttpRequest ()<UIAlertViewDelegate>

@end


@implementation HttpRequest
+ (void)commonNetRequestUrl:(NSString *)requestUrl Paramete:(id)parDict respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;{
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [[AFNRequestManager shareAFNRequestManager] POST:requestUrl parameters:parDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSNumber*errorNum=[dictionary objectForKey:@"c"];
            NSString*errorString=[NSString stringWithFormat:@"%@",errorNum];
            if ([errorString isEqualToString:@"1"]) {
                success(dictionary);
            }else if([errorString intValue] == 10000){
                success(dictionary);
            }else if([errorString integerValue] == 20000){
                success(dictionary);
            }else{
                [ControlsManager showXLAlterViewWithContentTitle:[dictionary objectForKey:@"m"]];
                faild(errorString);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DebugLog(@"%@",error);
        faild(error);
    }];
}


+ (void)showHUDNetRequestUrl:(NSString *)requestUrl Paramete:(id)parDict requestView:(UIView *)view respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;{

    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.color = [UIColor clearColor];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    
    [[AFNRequestManager shareAFNRequestManager] POST:requestUrl parameters:parDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            NSNumber*errorNum=[dictionary objectForKey:@"c"];
            NSString*errorString=[NSString stringWithFormat:@"%@",errorNum];
            if ([errorString isEqualToString:@"1"]) {
                success(dictionary);
            }else if([errorString intValue] == 10000){
                success(dictionary);
            }else if([errorString integerValue] == 20000){
                success(dictionary);
            }else{
                // [ControlsManager showAlertViewWithTitle:[dictionary objectForKey:@"m"]];
                faild(errorString);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         DebugLog(@"%@",error);
        faild(error);
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
}




+ (void)post:(NSString *)urlStr param:(NSDictionary *)dict imageKey:(NSString *)key image:(UIImage *)image respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData * imageData = nil;
    imageData = UIImagePNGRepresentation(image);
    
    if (imageData.length == 0) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    [[AFNRequestManager shareAFNRequestManager] POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:key fileName:@"1.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DebugLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dictionary);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    
}

+ (NSData *)paramToJsonDataWithDict:(NSDictionary *)dict{

    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            DebugLog(@"[%@] Post Json Error: %@", [self class], dict);
        }
        else
        {
            DebugLog(@"[%@] Post Json : %@", [self class], dict);
        }
        return data;
    }else
    {
        DebugLog(@"[%@] Post Json is not valid: %@", [self class], dict);
    }
    return nil;
}

+ (void)commonNetRequestUrl:(NSString *)requestUrl Paramete:(id)parDict isShowHud:(BOOL)isShow respondBlock:(RespondBlock)success faildBlock:(FaildBlock)faild;{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [self paramToJsonDataWithDict:parDict];
        
        if ([NSString isEmpty:requestUrl])
        {
            DebugLog(@"[%@]请求出错了", [requestUrl class]);
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
                [[HUDHelper sharedInstance] syncLoading];
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
                    [[HUDHelper sharedInstance] syncStopLoading];
                });
            }
            
            
            if (error != nil)
            {
                DebugLog(@"Request = %@, Error = %@", requestUrl, error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ControlsManager showXLAlterViewWithContentTitle:[error localizedDescription]];
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
                        [ControlsManager showXLAlterViewWithContentTitle:responseString];
                    });
                    faild(nil);
                } else{
                    DebugLog(@"------------responsString:%@",responseString);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dictionary objectForKey:@"errorCode"] intValue] == 90002) {
                            
                        }else{
                            NSString * erroInfo = [NSString stringWithFormat:@"KKYERROR:%@",[dictionary objectForKey:@"errorCode"]];
                            [ControlsManager showXLAlterViewWithContentTitle:NSLocalizedString(erroInfo, nil)];
                            
                        }
                        faild(dictionary);
                    });
                    
                }
            }
        }];
        
        [task resume];
    });
}


- (void)dealloc{
    DebugLog(@"=========[%@] release成功>>>>>>>>>", NSStringFromClass([self class]));
}


@end
