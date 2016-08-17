//
//  WBTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/25.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "WBTableViewCell.h"
#import "URL.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@implementation WBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadViewsWithModel:(WBModel *)model
{
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SYPMW/2 - SYPMW/8 - 25, 5, SYPMW/4 + 50, SYPMW/2 + 40)];
    _backIm.frame = CGRectMake(0, 0, SYPMW , SYPMW/2 + 50);
    
    if (SCREEN_5S) {
        _title.font = [UIFont systemFontOfSize:14];
        _time.font = [UIFont systemFontOfSize:11];
        _pleace.font = [UIFont systemFontOfSize:11];
    }else{
        _title.font = [UIFont systemFontOfSize:16];
        _time.font = [UIFont systemFontOfSize:13];
        _pleace.font = [UIFont systemFontOfSize:13];
    }
    
    //显示图片
    NSString * imUrlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,model.titlepage];
    NSURL * imUrl = [NSURL URLWithString:imUrlStr];
//    [_backIm sd_setImageWithURL:imUrl placeholderImage:[UIImage imageNamed:@"tphc6"]];
    [_backIm setImage:[UIImage imageNamed:@"bg"]];
    [image sd_setImageWithURL:imUrl placeholderImage:[UIImage imageNamed:@"tphc6"]];
//    UIImage *lastImage = [_backIm.image applyDarkEffect];//一句代码搞定毛玻璃效果
//    _backIm.image = lastImage;
//    _backIm.userInteractionEnabled = YES;

    //显示标题
//    CGFloat _pleaceY = CGRectGetMaxY(_starTime.frame)+5;
    
    CGFloat _titleY = CGRectGetMaxY(_backIm.frame)+8;
    _title.frame = CGRectMake(8, _titleY, SYPMW, 18);
    _title.text = model.title;
    //显示时间
    CGFloat _timeY = CGRectGetMaxY(_title.frame)+8;
    _time.frame = CGRectMake(8, _timeY, SYPMW, 10);
    NSString * time = [NSString stringWithFormat:@"时间 : %@ 至 %@",model.sta,model.stp];
    _time.text = time;
    
    //显示地点
    CGFloat _pleaceY = CGRectGetMaxY(_time.frame)+8;
    _pleace.frame = CGRectMake(8, _pleaceY, SYPMW, 10);
    NSString * pleace = [NSString stringWithFormat:@"地点 : %@",model.place];
    _pleace.text = pleace;
    
    [self addSubview:image];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
