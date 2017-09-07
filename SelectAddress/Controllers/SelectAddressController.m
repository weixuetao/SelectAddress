//
//  SelectAddressController.m
//  SelectAddress
//
//  Created by 魏学涛 on 2017/9/4.
//  Copyright © 2017年 Weixuetao. All rights reserved.
//

#import "SelectAddressController.h"
#import "HttpRequest.h"
#import "AreaModel.h"
#import "SelectAddressView.h"

@interface SelectAddressController ()<SelectAddressViewDelegate>

@property (nonatomic, strong) SelectAddressView * addressView;      //地区选择视图

@property (nonatomic, strong) UIButton * selectButton;

@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) NSMutableArray * addressArray;

@end

@implementation SelectAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    [self layoutAddressSelectUI];
    
    
}

- (void)layoutAddressSelectUI{
    //地址标签
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/2-100, 100, 200, 30)];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.textColor = [UIColor redColor];
    self.addressLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.addressLabel];
    
    //地址选择按钮
    self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(DeviceWidth/2-30, 150, 60, 30)];
    self.selectButton.backgroundColor = [UIColor orangeColor];
    [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectButton];
}


- (void)selectButtonAction:(UIButton *)btn{
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"areaSelect.plist" ofType:nil];
    NSArray * addressArray = [NSArray arrayWithContentsOfFile:filePath];
    
    if (self.addressArray.count== 0) {
        self.addressArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary * tempDict in addressArray) {
            [self.addressArray addObject:[AreaModel mj_objectWithKeyValues:tempDict]];
        }
    }
    self.addressView.addressArray = self.addressArray;
    [self.addressView showSelectAddressView];
}

- (SelectAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) withSelectedAddress:nil];
        _addressView.delegate = self;
    }
    return _addressView;
}

//@[@"辽宁",@"抚顺",@"望花"]
- (void)finishedSelectAddressWithSelectedArray:(NSArray *)selectedArray{
    NSString * addressStr = @"";
    for (NSString * tempAddress in selectedArray) {
        addressStr = [addressStr stringByAppendingString:tempAddress];
    }
    self.addressLabel.text = addressStr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
