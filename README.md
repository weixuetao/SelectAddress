# SelectAddress
模仿京东的地区选择，具有很好的扩展性，使用简单

1.
/**
 初始化方法

 @param frame frame
 @param selectedArray 已选中地址
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withSelectedAddress:(NSArray *)selectedArray;

2.
@property (nonatomic, strong) NSArray * addressArray;地址请求的数据或者本地数据

3.
/**
 代理回调

 @param selectedArray 返回的地址数组
 */
- (void)finishedSelectAddressWithSelectedArray:(NSArray *)selectedArray;
接受到回调后只需要拼接字符串就行


