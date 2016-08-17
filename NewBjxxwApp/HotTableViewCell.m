//
//  HotTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/13.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "HotTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URL.h"

#define ImX self.frame.size.width - 20
#define ImY self.frame.size.height - 8
#define ImW [UIScreen mainScreen].bounds.size.width / 3
#define ImH [UIScreen mainScreen].bounds.size.width/2

@interface HotTableViewCell ()
{
    int SelfWhit;
}
@end

@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadViewsWithModel:(HotModel *)model
{

    
    NSString * str = [NSString stringWithFormat:@"%@%@",BaseUrl,model.path];
    //图片地址网页
    NSURL * url = [NSURL URLWithString:str];
    //活动地点
    NSString * place = [NSString stringWithFormat:@"地点: %@",model.place];
    //活动时间
    NSString * st = [NSString stringWithFormat:@"时间: %@",model.st];
    
    //image的位置
    [_rImage setFrame:CGRectMake(15, 8, ImW - 15, ImH-36)];
    
    [_rImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tphc6"]];
    
//    NSLog(@"图片的高度%f",_rImage.frame.size.height);
    
    //title的位置and一些设定
    CGFloat  WX = ImW + 10;
    CGFloat  WX2 = ImW * 2 - 10;
    _title.frame = CGRectMake(WX, 8, WX2, _rImage.frame.size.height/3 -8 );
    _title.numberOfLines = 0;
    _title.font = [UIFont systemFontOfSize:13];
    _title.text = model.title;
    
    //开始时间的问题
   // CGFloat _starTimeY = CGRectGetMaxY(_title.frame)+10;
    _starTime.frame = CGRectMake(WX , _rImage.frame.size.height/3+ 5, WX2, _rImage.frame.size.height/3/3);
    _starTime.font = [UIFont systemFontOfSize:13];
    _starTime.text = st;
    
    //地点
    CGFloat _pleaceY = CGRectGetMaxY(_starTime.frame)+5;
    _pleace.frame = CGRectMake(WX , _pleaceY,WX2, _rImage.frame.size.height/3/3);
    _pleace.text = place;
    
    
    
    _introduce.text = model.area;
    CGFloat _introduceY = CGRectGetMaxY(_pleace.frame)+5;
    _introduce.frame = CGRectMake(WX , _introduceY,WX2,_rImage.frame.size.height/3/3);
    NSLog(@"%@",model.place);
    
    
    if (SCREEN_4S || SCREEN_5S) {
        SelfWhit = 20;
    }else{
    SelfWhit = 25;
    }
    NSLog(@"%d",SelfWhit);
    CGFloat _ljImageY = CGRectGetMaxY(_introduce.frame)+10;
    _ljImage.frame = CGRectMake(WX, _ljImageY, ImW *2 /3-20,  _rImage.frame.size.height/3 -SelfWhit);
    
    _ljck.image = [UIImage imageNamed:@"ljck"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
