//
//  AreaModel.h
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject


@property (nonatomic, strong) NSString * region_id;     //地区id

@property (nonatomic, strong) NSString *region_name;    //地区名称

@property (nonatomic, strong) NSArray * children;       //子地区

@end
