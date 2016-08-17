//
//  SearchTableViewCell.m
//  北京信息网·活动
//
//  Created by LiHanlun on 16/6/20.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URL.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadViewsWithModel:(SearchModel *)model
{
    NSString * st = [NSString stringWithFormat:@"%@%@",BaseUrl,model.path];
    NSURL * url = [NSURL URLWithString:st];
    [_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tphc5"]];
    NSString * time = [NSString stringWithFormat:@"时间:%@ ~ %@",model.st,model.de];
    _time.text = time;
    _title.text = model.title;
    NSString * place = [NSString stringWithFormat:@"地点:%@",model.place];
    _place.text = place;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
