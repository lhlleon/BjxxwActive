//
//  HotPLTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/26.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotPlModel.h"

@interface HotPLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *txImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

-(void)loadViewsWithModel:(HotPlModel *)model;


@end
