//
//  SelectAddressView.h
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAddressViewDelegate <NSObject>


/**
 代理回调

 @param selectedArray 已选中地址
 */
- (void)finishedSelectAddressWithSelectedArray:(NSArray *)selectedArray;

@end

@interface SelectAddressView : UIView

@property (nonatomic, weak) id<SelectAddressViewDelegate>delegate;

@property (nonatomic, strong) NSArray * addressArray;



/**
 初始化方法

 @param frame frame
 @param selectedArray 地址数据
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withSelectedAddress:(NSArray *)selectedArray;


- (void)showSelectAddressView;      //显示地址选择视图

@end
