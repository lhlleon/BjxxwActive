//
//  XQTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/16.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiangQingModel.h"

@interface XQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *bimge;

@property (weak, nonatomic) IBOutlet UIImageView *ljbm;

-(void)loadViewsWithModel:(XiangQingModel *)model;
@end
