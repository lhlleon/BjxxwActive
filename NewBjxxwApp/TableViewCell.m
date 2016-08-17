//
//  TableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/6.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "TableViewCell.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHToast.h"

@interface TableViewCell ()

@property (nonatomic,strong) NSString * order;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * titles;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //获取用户uid
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.uid =[defaults objectForKey:@"uid"];
}

-(void)loadViewsWithModel:(BaoMingModel *)model
{
    self.price = model.price;//价格
    self.titles = model.title;//标题
    self.order = model.order_code;//订单号
    self.hid = model.hid;
    
    _dingdanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dianping = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (SCREEN_5S) {
        _bjxxw.font = [UIFont systemFontOfSize:13];
        _zhuangtai.font = [UIFont systemFontOfSize:13];
        _title.font = [UIFont systemFontOfSize:13];
        _money.font = [UIFont systemFontOfSize:13];
    }else{
        _bjxxw.font = [UIFont systemFontOfSize:17];
        _zhuangtai.font = [UIFont systemFontOfSize:17];
        _title.font = [UIFont systemFontOfSize:17];
        _money.font = [UIFont systemFontOfSize:17];
    }
    
    _shutiao.frame = CGRectMake(15, 8, 2, 20);
    _bjxxw.frame = CGRectMake(25, 8, 100, 20);
    _zhuangtai.frame = CGRectMake(SYPMW-65, 8, SYPMW-50, 20);
    
    CGFloat _fgaY = CGRectGetMaxY(_shutiao.frame)+8;
    _fga.frame = CGRectMake(10, _fgaY, SYPMW-20, 2);
    
    CGFloat _imageY = CGRectGetMaxY(_fga.frame)+8;
    _image.frame = CGRectMake(25, _imageY, SYPMW/3, SYPMW/2);
    
    //标题
    CGFloat _imageX = CGRectGetMaxX(_image.frame)+5;
    _title.frame = CGRectMake(_imageX, _imageY, SYPMW-_imageY, 50);
    _title.numberOfLines = 0;
    //自动换行属性
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [_title sizeThatFits:CGSizeMake( _title.frame.size.width, MAXFLOAT)];
    [_title setFrame:CGRectMake(_imageX, _imageY, SYPMW-_image.frame.size.width - 40, size.height +30)];
    
    //金额
    CGFloat _moneyY = CGRectGetMaxY(_title.frame)+8;
    _money.frame = CGRectMake(_imageX, _moneyY, 100, 20);
    
    CGFloat _fgbY = CGRectGetMaxY(_image.frame)+8;
    _fgb.frame = CGRectMake(10, _fgbY, SYPMW-20, 2);
    
    //取消.删除订单
    CGFloat _ddButtonY = CGRectGetMaxY(_fgb.frame)+5;
    _dingdanButton.frame = CGRectMake(SYPMW/2, _ddButtonY, 80, 25);
    
    //评论/付款
    _dianping.frame = CGRectMake(SYPMW/2+100, _ddButtonY, 40, 25);
    
    NSString * str = [NSString stringWithFormat:@"%@%@",BaseUrl,model.path];
    NSURL * url = [NSURL URLWithString:str];
    NSString * money = [NSString stringWithFormat:@"¥:%@",model.price];
    
    [_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tphc6"]];
    
    _title.text = model.title;
    
    _money.text = money;
    
    if ([model.if_baoming  isEqual: @"1"]) {
        _zhuangtai.text = @"已完成";
        [_dingdanButton setBackgroundImage:[UIImage imageNamed:@"scdd"] forState:UIControlStateNormal];
        [_dianping setBackgroundImage:[UIImage imageNamed:@"pll"] forState:UIControlStateNormal];
        [_dingdanButton addTarget:self action:@selector(ywcDDB:) forControlEvents:UIControlEventTouchUpInside];
        [_dianping addTarget:self action:@selector(plBBD:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _zhuangtai.text = @"待付款";
        [_dingdanButton setBackgroundImage:[UIImage imageNamed:@"qxdd"] forState:UIControlStateNormal];
        [_dianping setBackgroundImage:[UIImage imageNamed:@"fk"] forState:UIControlStateNormal];
        [_dingdanButton addTarget:self action:@selector(qxDDB:) forControlEvents:UIControlEventTouchUpInside];
        [_dianping addTarget:self action:@selector(fukuan:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:_dingdanButton];
    [self addSubview:_dianping];
    
    
    //获取order还有hid
    self.order_code = model.order_code;
    self.hid = model.hid;
}

-(void)ywcDDB:(UIButton *)dingdanButton
{
    
    //订单删除

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"uid":self.uid,@"hid":self.hid,@"order_code":self.order_code};
    NSLog(@"%@",self.uid);
    
    [manager POST:SCDD parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"arr==%@",arr);
        
        NSString * str = [NSString stringWithFormat:@"%@",[arr[0]objectForKey:@"tishi"]];
//        NSLog(@"%@",str);
        
        if ([str isEqualToString:@"1"]) {
//            NSLog(@"已删除");
            /**
             *  删除订单的提示
             */
            NSString * str = @"已删除";
            [XHToast showBottomWithText:str];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin1" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin2" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin3" object:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
}

-(void)plBBD:(UIButton *)dianping
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan4" object:self.hid];//把评论需要的hid传过去,在进行页面的跳转,,,否则hid为null
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dianping" object:nil];
}

-(void)qxDDB:(UIButton *)dingdanButton
{
    //取消订单!(未付款状态!)
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"uid":self.uid,@"hid":self.hid,@"order_code":self.order_code};
    NSLog(@"%@",self.uid);
    
    [manager POST:QXDD parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //        NSLog(@"arr==%@",arr);
        
        NSString * str = [NSString stringWithFormat:@"%@",[arr[0]objectForKey:@"tishi"]];
        //        NSLog(@"%@",str);
        
        if ([str isEqualToString:@"1"]) {
//            NSLog(@"已删除");
            /**
             *  取消订单的显示
             */
            NSString * str = @"已取消";
            [XHToast showBottomWithText:str];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin1" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin2" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin3" object:nil];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}
-(void)fukuan:(UIButton *)dianping
{
#warning 这是付款的那个界面!!!稍后要写的!!!!注意!!!!warning!!!!!
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan1" object:self.price];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan2" object:self.titles];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan3" object:self.order];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan4" object:self.hid];
    NSLog(@"2");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fukuan" object:nil];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
