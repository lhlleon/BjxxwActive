//
//  XQTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/16.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "XQTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URL.h"


#define ImX self.frame.size.width - 20
#define ImY self.frame.size.height - 8
#define ImW [UIScreen mainScreen].bounds.size.width / 3
#define ImH [UIScreen mainScreen].bounds.size.width/2

@interface XQTableViewCell ()
{
    int SelfWhit;
}

@end

@implementation XQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadViewsWithModel:(XiangQingModel *)model
{
    NSString * str = [NSString stringWithFormat:@"%@%@",BaseUrl,model.path];
    //图片地址网页
    NSURL * url = [NSURL URLWithString:str];
    
//    NSLog(@"%@",url);
    
    //活动地点
    NSString * place = [NSString stringWithFormat:@"地点: %@",model.place];
    
    //活动时间
    NSString * st = [NSString stringWithFormat:@"时间: %@",model.de];
    
    //价格
    NSString * price = [NSString stringWithFormat:@"价格: %@",model.price];

    //image的位置
    [_Image setFrame:CGRectMake(15, 8, ImW - 15, ImH-36)];
    //存取图片
    [_Image sd_setImageWithURL:url];
    
    //title的位置and一些设定
    CGFloat  WX = ImW + 10;
    CGFloat  WX2 = ImW * 2 - 10;
    _title.frame = CGRectMake(WX, 8, WX2, _Image.frame.size.height/3 -8 );
    _title.numberOfLines = 0;
    _title.font = [UIFont systemFontOfSize:13];
    _title.text = model.title;
    
    //开始时间的问题
    // CGFloat _starTimeY = CGRectGetMaxY(_title.frame)+10;
    _time.frame = CGRectMake(WX , _Image.frame.size.height/3+ 5, WX2, _Image.frame.size.height/3/3);
    _time.font = [UIFont systemFontOfSize:13];
    _time.text = st;
    
    //地点
    CGFloat _pleaceY = CGRectGetMaxY(_time.frame)+5;
    _place.frame = CGRectMake(WX , _pleaceY,WX2, _Image.frame.size.height/3/3);
    _place.text = place;
    
    //价格
    _price.text = price;
    CGFloat _priceY = CGRectGetMaxY(_place.frame)+5;
    _price.frame = CGRectMake(WX , _priceY,WX2,_Image.frame.size.height/3/3);
//    NSLog(@"%@",model.place);
    
    
    if (SCREEN_4S || SCREEN_5S) {
        SelfWhit = 20;
    }else{
        SelfWhit = 25;
    }
//    NSLog(@"%d",SelfWhit);
    CGFloat _ljImageY = CGRectGetMaxY(_price.frame)+10;
    _bimge.frame = CGRectMake(WX, _ljImageY, ImW *2 /3-20,  _Image.frame.size.height/3 -SelfWhit);
    
    _ljbm.image = [UIImage imageNamed:@"ljbm"];
    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
