//
//  HDXQTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "HDXQTableViewCell.h"
#import "URL.h"
#import "UIImageView+WebCache.m"

@implementation HDXQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadViewsWithModel:(YHXQModel *)model{
    
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SYPMW/2 - SYPMW/8 - 25, 5, SYPMW/4 + 50, SYPMW/2 + 40)];
    _backImage.frame = CGRectMake(0, 0, SYPMW , SYPMW/2 + 50);
    //显示图片
    
    NSString * imUrlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,model.path];
    NSURL * imUrl = [NSURL URLWithString:imUrlStr];
//    [_backImage sd_setImageWithURL:imUrl placeholderImage:[UIImage imageNamed:@"tphc6"]];
    [_backImage setImage:[UIImage imageNamed:@"hcpt"]];
    [image sd_setImageWithURL:imUrl placeholderImage:[UIImage imageNamed:@"tphc6"]];
    
    //title的位置和显示内容
    _title.text = model.title;
    CGFloat _titleY = CGRectGetMaxY(_backImage.frame)+8;
    _title.frame = CGRectMake(15, _titleY, SYPMW-15, 10);
    
    //xVIew一条线
    CGFloat _xViewY = CGRectGetMaxY(_title.frame)+8;
    _Xview.frame = CGRectMake(15, _xViewY, SYPMW-25, 1);
    
    //时间
    CGFloat _timeY = CGRectGetMaxY(_title.frame)+15;
    _time.frame = CGRectMake(25, _timeY, SYPMW-32, 10);
    NSString * time = [NSString stringWithFormat:@"时间:%@ 至 %@",model.st,model.de];
    _time.text = time;
    
    //地点
    NSString * pleace = [NSString stringWithFormat:@"地点:%@",model.place];
    CGFloat _pleaceY = CGRectGetMaxY(_time.frame) + 8;
    _pleace.frame = CGRectMake(25, _pleaceY, SYPMW-32, 10);
    _pleace.text = pleace;
    
    //电话号码
    NSString * phone = [NSString stringWithFormat:@"电话:%@",model.tel];
    CGFloat _phoneY = CGRectGetMaxY(_pleace.frame) + 8;
    _phone.frame = CGRectMake(25, _phoneY, SYPMW-32, 13);
    _phone.text = phone;
    
    //QQ号码
    NSString * QQ = [NSString stringWithFormat:@"QQ:%@",model.qq];
    CGFloat _qqY = CGRectGetMaxY(_phone.frame) + 8;
    _qq.frame = CGRectMake(26, _qqY, SYPMW-32, 13);
    _qq.text = QQ;
    
    //字体设置
    if (SCREEN_5S) {
        _title.font = [UIFont systemFontOfSize:14];
        _time.font = [UIFont systemFontOfSize:13];
        _pleace.font = [UIFont systemFontOfSize:13];
        _phone.font = [UIFont systemFontOfSize:13];
        _qq.font = [UIFont systemFontOfSize:13];
    }
    
    
    
    
    [self addSubview:image];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
