//
//  AreaTableViewCell.h
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaModel;
@protocol AreaTableViewCellDelegate <NSObject>


/**
 点击当前表时间的处理

 @param row 行
 @param cellTag 当前父试图cell的tag
 */
- (void)areaTableViewCellDidSelectRow:(NSInteger)row withTag:(NSInteger)cellTag currentArea:(AreaModel *)areaModel;

@end

@interface AreaTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AreaTableViewCellDelegate>delegate;

@property (nonatomic, strong) NSArray * addressArray;    //加载数据

@property (nonatomic, strong) NSArray * cacheArray;     //本地保存的地址数组

@end
