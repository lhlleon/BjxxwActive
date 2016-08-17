//
//  myPLTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/16.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "myPLTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URL.h"
#import "AFNetworking.h"
#import "XHToast.h"
#import "MJExtension.h"

@interface myPLTableViewCell ()

@property (nonatomic,strong) NSString * hid;

@property (nonatomic,strong) NSString * uid;
@end

@implementation myPLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.kuang.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.kuang.layer.borderWidth = 2;

}

-(void)loadViewsWithModel:(MYPLModel *)model
{
    
    NSString * st = [[NSString alloc]init];
    if ([model.face rangeOfString:@"app"].location != NSNotFound) {
        st = [NSString stringWithFormat:@"%@%@",BaseUrl,model.face];
    }else{
        st = [NSString stringWithFormat:@"%@%@",TPXSURL,model.face];

    }
    
    NSURL * url = [NSURL URLWithString:st];
    NSString * time = [NSString stringWithFormat:@"发布时间 : %@",model.st];
    _titles.text = model.title;//标题
    [_headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tx"]];//头像
    _content.text = model.content;//发布内容
    _stime.text = time;//发布时间
    self.hid = model.hid;
}


- (IBAction)SCDelete:(id)sender {
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    
    //网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid,@"uid":self.uid};
    
    [manager POST:ShanChuPl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",arr);
        
        NSString * st = [NSString stringWithFormat:@"%@",[arr[0]objectForKey:@"tishi"]];
        
        [XHToast showBottomWithText:st];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
