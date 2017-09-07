//
//  SelectAddressView.m
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import "SelectAddressView.h"
#import "AreaTableViewCell.h"
#import "AreaModel.h"

@interface SelectAddressView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AreaTableViewCellDelegate>

@property (nonatomic, strong) UIView *bgView;                       //底部父试图

@property (nonatomic, strong) UITableView * addressTableView;       //

@property (nonatomic, strong) UIScrollView * tabItemsView;          //顶部地址视图

@property (nonatomic, strong) NSArray       * selectedArray;        //传入的选择过的地址

@property (nonatomic, strong) UILabel       * horizontalLabel;      //横向移动视图

@property (nonatomic, assign) NSInteger     cellCount;         //等级个数

@property (nonatomic, strong) NSMutableArray       * cacheArray;           //用来存储选中的地址

@property (nonatomic, strong) AreaModel     *provienceModel;      //省

@property (nonatomic, strong) AreaModel     *cityModel;           //市

@property (nonatomic, strong) AreaModel     * countyModel;        //区
@end

@implementation SelectAddressView


- (instancetype)initWithFrame:(CGRect)frame withSelectedAddress:(NSArray *)selectedArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedArray = selectedArray;
        [self layoutSelectAddressUI];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSelectAddressUI];

    }
    return self;
}

- (void)setAddressArray:(NSArray *)addressArray{
    _addressArray = addressArray;
    if (_selectedArray.count>0) {
        [self enumerateAddressGetData];
        _cellCount = self.cacheArray.count;
        [self.addressTableView reloadData];
        
        [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_cacheArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        UIButton * itemButton = [self.tabItemsView viewWithTag:self.cacheArray.count+9];
        [self addressButtonAction:itemButton];
    }
}

- (void)layoutSelectAddressUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.cacheArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.selectedArray.count>0) {
        self.cacheArray = [self.selectedArray mutableCopy];
    }
    //添加底部视图
    [self addSubview:self.bgView];
    
    //头部标题
    UILabel * addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, DeviceWidth, 20)];
    addressTitleLbl.textAlignment = NSTextAlignmentCenter;
    addressTitleLbl.textColor = [UIColor colorWithRed:168.0/255.0 green:169.0/255.0 blue:171.0/255.0 alpha:1.0];
    addressTitleLbl.font = [UIFont systemFontOfSize:13];
    addressTitleLbl.text = @"所在地区";
    [self.bgView addSubview:addressTitleLbl];
    
    //横线
    UILabel * underLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, DeviceWidth, 1)];
    underLine.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.bgView addSubview:underLine];
    
    [self.bgView addSubview:self.horizontalLabel];
    
    //顶部滚动视图
    [self.bgView addSubview:self.tabItemsView];
    
    //添加地址tab
    [self latyouScrollViewChildrenUI];
    
    //选择table
    [self.bgView addSubview:self.addressTableView];
    
}



/**
 顶部scrollview，地址的父试图
 */
- (UIScrollView *)tabItemsView{
    if (!_tabItemsView) {
        _tabItemsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, DeviceWidth, 20)];
        _tabItemsView.showsVerticalScrollIndicator = NO;
        _tabItemsView.showsHorizontalScrollIndicator = NO;
        _tabItemsView.bounces = NO;
    }
    return _tabItemsView;
}

- (void)latyouScrollViewChildrenUI{
    for (int i = 0; i<self.selectedArray.count; i++) {
        UIButton * addressButton = [self createAddressButtonWithTitle:self.selectedArray[i] withButtonTag:10+i];
        addressButton.frame = CGRectMake(i*DeviceWidth/4, 0, DeviceWidth/4, 20);
        [self.tabItemsView addSubview:addressButton];
        self.cellCount = self.selectedArray.count;
    }
    
    if (self.addressArray.count == 0&&self.selectedArray.count == 0) {
        UIButton * addressButton = [self createAddressButtonWithTitle:@"请选择" withButtonTag:10];
        addressButton.selected = YES;
        addressButton.frame = CGRectMake(0, 0, DeviceWidth/4, 20);
        [self.tabItemsView addSubview:addressButton];
        self.cellCount = 1;
        
    }
}

- (UIButton *)createAddressButtonWithTitle:(NSString *)addressString withButtonTag:(NSInteger)tag{
    UIButton * addressButton = [[UIButton alloc] init];
    [addressButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressButton setTitle:addressString forState:UIControlStateNormal];
    addressButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [addressButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addressButton.tag = tag;
    return addressButton;
}


- (UILabel *)horizontalLabel{
    if (!_horizontalLabel) {
        _horizontalLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/16, 61, DeviceWidth/8, 2)];
        _horizontalLabel.backgroundColor = [UIColor redColor];
    }
    return _horizontalLabel;
}

/**
 底部视图
 */
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceWidth+63)];
        
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


/**
 表
 */
- (UITableView *)addressTableView{
    if (!_addressTableView) {
        _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63, DeviceWidth, DeviceWidth) style:UITableViewStylePlain];
        _addressTableView.delegate = self;
        _addressTableView.dataSource = self;
        _addressTableView.scrollsToTop = NO;
        _addressTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addressTableView.showsVerticalScrollIndicator = NO;
        _addressTableView.pagingEnabled = YES;
        _addressTableView.bounces = NO;
    }
    return _addressTableView;
}

- (void)layoutSubviews{
    
}

#pragma mark -------------UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"address";
    AreaTableViewCell * cell = (AreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tag = indexPath.row+1;
    cell.cacheArray = self.cacheArray;
    switch (indexPath.row) {
        case 0:
            cell.addressArray = self.addressArray;
    
            break;
        case 1:
            cell.addressArray = self.provienceModel.children;
            break;
        case 2:
            cell.addressArray = self.cityModel.children;
            break;
            
        default:
            break;
    }
    cell.delegate = self;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.width;
}

#pragma mark ---------------AreaTableViewCellDelegate
- (void)areaTableViewCellDidSelectRow:(NSInteger)row withTag:(NSInteger)cellTag currentArea:(AreaModel *)areaModel{
    int areaLevel = (int)cellTag-1;
    
    switch (areaLevel) {
        case 0:     //省（或市）
        {
            if (self.cacheArray.count>0) {
                NSString * cacheProvience = self.cacheArray[0];
                if (![cacheProvience isEqualToString:areaModel.region_name]) {
                    [self.cacheArray removeAllObjects];
                    [self.cacheArray addObject:areaModel.region_name];
                }else{
                    return;
                }
            }else{
                [self.cacheArray addObject:areaModel.region_name];
            }
            self.provienceModel = areaModel;
            
            //刷新下级视图
            if (areaModel.children.count>0) {
                self.cellCount =2;
                [self.addressTableView reloadData];
                [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                if ([self.delegate respondsToSelector:@selector(finishedSelectAddressWithSelectedArray:)]) {
                    [self.delegate finishedSelectAddressWithSelectedArray:self.cacheArray];
                    [self hiddenSelectAddressView];
                }
            }
        }
            break;
        case 1:     //市（或区）
        {
            if (self.cacheArray.count == 1) {
                [self.cacheArray  addObject:areaModel.region_name];
            }else{
                //删除后面级别的元素
                if (self.cacheArray.count>2) {
                    [self.cacheArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                        if (idx>1) {
                            [self.cacheArray removeObject:obj];
                        }
                    }];
                }
                
                [self.cacheArray replaceObjectAtIndex:1 withObject:areaModel.region_name];
            }
            self.cityModel = areaModel;
            if (areaModel.children.count>0) {
                self.cellCount =3;
                [self.addressTableView reloadData];
                [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                if ([self.delegate respondsToSelector:@selector(finishedSelectAddressWithSelectedArray:)]) {
                    [self.delegate finishedSelectAddressWithSelectedArray:self.cacheArray];
                    [self hiddenSelectAddressView];
                }
            }
        }
            break;
        case 2:     //
        {
            if (self.cacheArray.count == 2) {
                [self.cacheArray  addObject:areaModel.region_name];
            }else{
                //删除后面级别的元素
                if (self.cacheArray.count>3) {
                    [self.cacheArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                        if (idx>2) {
                            [self.cacheArray removeObject:obj];
                        }
                    }];
                }
                [self.cacheArray replaceObjectAtIndex:2 withObject:areaModel.region_name];
            }
            if (areaModel.children.count>0) {
                self.cellCount = 4;
                [self.addressTableView reloadData];
                [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                if ([self.delegate respondsToSelector:@selector(finishedSelectAddressWithSelectedArray:)]) {
                    [self.delegate finishedSelectAddressWithSelectedArray:self.cacheArray];
                    [self hiddenSelectAddressView];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    [self onSelectRelayoutScrollViewUIWithCellLevel:areaLevel areaModel:areaModel];
}

- (void)onSelectRelayoutScrollViewUIWithCellLevel:(NSInteger)tag areaModel:(AreaModel *)areaModel{
    for (UIView * buttonView in self.tabItemsView.subviews) {
        if ([buttonView isKindOfClass:[UIButton class]]) {
            [buttonView removeFromSuperview];
        }
    }
    
    if (areaModel.children.count == 0) {
        for (int i = 0; i<self.cacheArray.count; i++) {
            UIButton * itemButton = [self createAddressButtonWithTitle:self.cacheArray[i]   withButtonTag:i+10];
            itemButton.frame = CGRectMake(i*DeviceWidth/4, 0, DeviceWidth/4, 20);
            if (i == self.cacheArray.count-1) {
                itemButton.selected = YES;
            }
            [self.tabItemsView addSubview:itemButton];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.horizontalLabel.frame = CGRectMake(DeviceWidth/16+(self.cacheArray.count-1)*DeviceWidth/4, 61, DeviceWidth/8, 2);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        for (int i = 0; i<self.cacheArray.count+1; i++) {
            if (i<self.cacheArray.count) {
                UIButton * itemButton = [self createAddressButtonWithTitle:self.cacheArray[i]   withButtonTag:i+10];
                itemButton.frame = CGRectMake(i*DeviceWidth/4, 0, DeviceWidth/4, 20);
                [self.tabItemsView addSubview:itemButton];
            }else{
                UIButton * itemButton = [self createAddressButtonWithTitle:@"请选择"  withButtonTag:i+10];
                itemButton.frame = CGRectMake(i*DeviceWidth/4, 0, DeviceWidth/4, 20);
                itemButton.selected = YES;
                [self.tabItemsView addSubview:itemButton];
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
             self.horizontalLabel.frame = CGRectMake(DeviceWidth/16+self.cacheArray.count*DeviceWidth/4, 61, DeviceWidth/8, 2);
        } completion:^(BOOL finished) {
            
        }];
    }
}


/**
 获取初始化传入的地址位置
 */
- (void)enumerateAddressGetData{
    [self.addressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AreaModel * tempProArea = (AreaModel *)obj;
        //获取provience
        if ([tempProArea.region_name isEqualToString:self.cacheArray[0]]) {
            self.provienceModel = tempProArea;
            //获取city
            if (tempProArea.children.count>0) {
                [tempProArea.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AreaModel * tempcityArea = (AreaModel *)obj;
                    if ([tempcityArea.region_name isEqualToString:self.cacheArray[1]]) {
                        self.cityModel = tempcityArea;
                        //获取区(暂时不需要)
                    }
                }];
            }
        }
    }];

}


#pragma mark --------------control
- (void)showSelectAddressView;{
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    [UIView animateWithDuration:0.26 animations:^{
        self.bgView.frame = CGRectMake(0, DeviceHeight-DeviceWidth-63, DeviceWidth, DeviceWidth+63);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hiddenSelectAddressView;
{
    [self.addressTableView reloadData];
    [UIView animateWithDuration:0.26 animations:^{
        self.bgView.frame = CGRectMake(0, DeviceHeight, DeviceWidth, DeviceWidth+63);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//点击按钮
- (void)addressButtonAction:(UIButton *)tabButton{
    
    [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tabButton.tag-10 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.horizontalLabel.frame = CGRectMake(DeviceWidth/16+(tabButton.tag -10)*DeviceWidth/4, 61, DeviceWidth/8, 2);
    } completion:^(BOOL finished) {
        
    }];
    
    //设置选中按钮状态
    for (UIView * itemButton in self.tabItemsView.subviews) {
        UIButton * tempButton = (UIButton *)itemButton;
        if (tempButton.tag != tabButton.tag) {
            tempButton.selected = NO;
        }else{
            tempButton.selected = YES;
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenSelectAddressView];
}

//减速完成（停止）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        int i = scrollView.contentOffset.y/DeviceWidth;
        
        //设置选中按钮状态
        for (UIView * itemButton in self.tabItemsView.subviews) {
            UIButton * tempButton = (UIButton *)itemButton;
            if (tempButton.tag != (i+10)) {
                tempButton.selected = NO;
            }else{
                tempButton.selected = YES;
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.horizontalLabel.frame = CGRectMake(DeviceWidth/16+i*DeviceWidth/4, 61, DeviceWidth/8, 2);
        } completion:^(BOOL finished) {
            
        }];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
