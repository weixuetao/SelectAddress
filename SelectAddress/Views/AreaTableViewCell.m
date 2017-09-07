//
//  AreaTableViewCell.m
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import "AreaTableViewCell.h"
#import "AreaModel.h"

@interface AreaTableViewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * areaTableView;

@end

@implementation AreaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.areaTableView];
    }
    return self;
}

- (void)setAddressArray:(NSArray *)addressArray{
    _addressArray = addressArray;
    [self.areaTableView reloadData];
}

- (UITableView *)areaTableView{
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceWidth) style:UITableViewStylePlain];
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
    }
    return _areaTableView;
}



#pragma mark -------------UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"areaCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    AreaModel * area = self.addressArray[indexPath.row];
    cell.textLabel.text = area.region_name;
    
    NSInteger currentCellTag = self.tag;
    NSString * addressStr = @"";
    if (currentCellTag <= self.cacheArray.count) {
        addressStr = self.cacheArray[currentCellTag-1];
    }
    if ([addressStr isEqualToString:area.region_name]) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel * selectModel = self.addressArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(areaTableViewCellDidSelectRow:withTag: currentArea:)]) {
        [self.delegate areaTableViewCellDidSelectRow:indexPath.row withTag:self.tag currentArea:selectModel];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
