//
//  FourPictureView.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/12.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "FourPictureView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "URL.h"

#define Klwidth self.frame.size.width
#define Klheight self.frame.size.height
#define oneWidth _oneButton.frame.size.width
#define twoWeight _twoButton.frame.size.width/2


@interface FourPictureView ()

{
    UIButton * fourButton;
    NSMutableArray * fourDate;
}

@end

@implementation FourPictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createFourButton];
        [self buttonWeiZhi];
    }
    return self;
}


-(void)buttonWeiZhi
{
    
    _oneButton = [[UIButton alloc]init];
    _twoButton = [[UIButton alloc]init];
    _threeButton = [[UIButton alloc]init];
    _fouerButton = [[UIButton alloc]init];
    
    [_oneButton setFrame:CGRectMake(0, 0, Klwidth/2-50, Klheight)];
    [_twoButton setFrame:CGRectMake(oneWidth, 0, Klwidth-oneWidth, Klheight/2)];
    [_threeButton setFrame:CGRectMake(oneWidth, Klheight/2, twoWeight, Klheight/2)];
    [_fouerButton setFrame:CGRectMake(oneWidth + twoWeight, Klheight/2, twoWeight, Klheight/2)];
    
    [_oneButton addTarget:self action:@selector(oneClick:) forControlEvents:UIControlEventTouchUpInside];
    [_twoButton addTarget:self action:@selector(twoClick:) forControlEvents:UIControlEventTouchUpInside];
    [_threeButton addTarget:self action:@selector(threeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_fouerButton addTarget:self action:@selector(fourClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _oneImage = [[UIImageView alloc]initWithFrame:_oneButton.frame];
    _twoImage = [[UIImageView alloc]initWithFrame:_twoButton.frame];
    _threeImage = [[UIImageView alloc]initWithFrame:_threeButton.frame];
    _fourImage = [[UIImageView alloc]initWithFrame:_fouerButton.frame];
    
    [self addSubview:_oneImage];
    [self addSubview:_twoImage];
    [self addSubview:_threeImage];
    [self addSubview:_fourImage];
    
    [self addSubview:_oneButton];
    [self addSubview:_twoButton];
    [self addSubview:_threeButton];
    [self addSubview:_fouerButton];
    

}


/**
 *  获取hid  发送消息  跳转到详情页面
 */
#pragma mark - 跳转
-(void)oneClick:(UIButton *)oneButton
{
    NSString * da = [NSString stringWithFormat:@"%@",[fourDate[0] objectForKey:@"hid"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fourtiao" object:da];
}
-(void)twoClick:(UIButton *)twoButton
{
    NSString * da = [NSString stringWithFormat:@"%@",[fourDate[1] objectForKey:@"hid"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fourtiao" object:da];
}
-(void)threeClick:(UIButton *)threeButton
{
    NSString * da = [NSString stringWithFormat:@"%@",[fourDate[2] objectForKey:@"hid"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fourtiao" object:da];
}
-(void)fourClick:(UIButton *)fouerButton
{
    NSString * da = [NSString stringWithFormat:@"%@",[fourDate[3] objectForKey:@"hid"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fourtiao" object:da];
}



-(void)createFourButton
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:FourUrl parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        fourDate = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",fourDate);
        [self createImage];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


-(void)createImage
{
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i< fourDate.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%@%@",BaseUrl,[fourDate[i] objectForKey:@"path"]];
        [array addObject:str];
    }
    
    NSURL * url1 = [NSURL URLWithString:array[0]];
    NSURL * url2 = [NSURL URLWithString:array[1]];
    NSURL * url3 = [NSURL URLWithString:array[2]];
    NSURL * url4 = [NSURL URLWithString:array[3]];
    
    [_oneImage sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"tphc2"]];
    [_twoImage sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"tphc3"]];
    [_threeImage sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"tphc4"]];
    [_fourImage sd_setImageWithURL:url4 placeholderImage:[UIImage imageNamed:@"tphc5"]];
}






@end
