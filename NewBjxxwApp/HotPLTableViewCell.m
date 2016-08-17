
//
//  HotPLTableViewCell.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/26.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "HotPLTableViewCell.h"
#import "URL.h"
#import "UIImageView+WebCache.h"

@implementation HotPLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadViewsWithModel:(HotPlModel *)model
{
    
//    //1.获取NSUserDefaults对象
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    //读取保存的数据
//    self.name.text = [defaults objectForKey:@"usernm"];
    
    
//    NSLog(@"52=== = = = = %@",model.face);
    
    NSString * imageU = [[NSString alloc]init];
    if ([model.face rangeOfString:@"app"].location != NSNotFound) {
        imageU = [NSString stringWithFormat:@"%@%@",BaseUrl,model.face];
    }else{
        
        imageU = [NSString stringWithFormat:@"%@%@",TPXSURL,model.face];

    }
    
    NSURL * imageUrl = [NSURL URLWithString:imageU];
    [_txImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"tx"]];
    _name.text = model.nickname;
    _content.text = model.content;
    _time.text = model.cr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
